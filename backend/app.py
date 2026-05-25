from flask import Flask, request, jsonify
from flask_cors import CORS
import jwt
import datetime
from functools import wraps
from models import db, Kit, SensorData
import os

app = Flask(__name__)
# Enable CORS for all routes and origins
CORS(app)

# SQLite database configuration
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'aquaguard.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Supabase Auth Secret
app.config['SUPABASE_JWT_SECRET'] = os.environ.get('SUPABASE_JWT_SECRET', 'YOUR_SUPABASE_JWT_SECRET_HERE')

db.init_app(app)

# Helper function to require JWT token
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        # JWT is passed in the request header (Bearer [TOKEN])
        if 'Authorization' in request.headers:
            parts = request.headers['Authorization'].split(" ")
            if len(parts) == 2:
                token = parts[1]
        
        if not token:
            return jsonify({'message': 'Token is missing!'}), 401
  
        try:
            # Verify the JWT using Supabase's HS256 secret key
            decoded_data = jwt.decode(token, app.config['SUPABASE_JWT_SECRET'], algorithms=["HS256"], audience="authenticated")
            
            # Extract Kit ID from Supabase user metadata
            user_metadata = decoded_data.get('user_metadata', {})
            kit_id = user_metadata.get('kit_id')
            
            if not kit_id:
                return jsonify({'message': 'No kit_id linked to this account in Supabase metadata.'}), 403
            
            return f(kit_id, *args, **kwargs)

        except Exception as e:
            return jsonify({'message': f'Token is invalid! {str(e)}'}), 401
        
    return decorated


@app.route('/api/data', methods=['GET'])
@token_required
def get_sensor_data(kit_id_string):
    # Lookup the physical kit by the string ID
    kit = Kit.query.filter_by(mac_address=kit_id_string).first()
    if not kit:
        return jsonify([{'error': 'Kit not registered in system'}]), 404

    # Fetch the latest 20 sensor data points
    kit_data = SensorData.query.filter_by(kit_id=kit.id).order_by(SensorData.timestamp.desc()).limit(20).all()
    
    result = []
    for data in kit_data[::-1]: # Reverse to have chronological order
        result.append({
            'timestamp': data.timestamp.isoformat() + 'Z',
            'ph': data.ph,
            'dissolved_oxygen': data.dissolved_oxygen,
            'tds': data.tds,
            'turbidity': data.turbidity,
            'ammonia': data.ammonia,
            'humidity': data.humidity,
            'temperature': data.temperature,
            'water_level': data.water_level
        })
    
    return jsonify(result), 200

# Optional: Endpoint to simulate kit sending data (Hardware side)
@app.route('/api/kit/data', methods=['POST'])
def post_kit_data():
    data = request.get_json()
    kit_mac = data.get('mac_address')
    
    if not kit_mac:
        return jsonify({'error': 'Missing mac_address in payload'}), 400

    kit = Kit.query.filter_by(mac_address=kit_mac).first()
    
    if not kit:
        # Auto-create kit if not exists
        kit = Kit(mac_address=kit_mac, name=f"Auto Kit {kit_mac}")
        db.session.add(kit)
        db.session.commit()
        
    sensor_data = SensorData(
        kit_id=kit.id,
        ph=data.get('ph', 7.0),
        dissolved_oxygen=data.get('dissolved_oxygen', 7.0),
        tds=data.get('tds', 200),
        turbidity=data.get('turbidity', 2.0),
        ammonia=data.get('ammonia', 0.0),
        humidity=data.get('humidity', 50.0),
        temperature=data.get('temperature', 25.0),
        water_level=data.get('water_level', 100)
    )
    db.session.add(sensor_data)
    db.session.commit()
    
    return jsonify({'message': 'Data recorded successfully'}), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, port=5000)
