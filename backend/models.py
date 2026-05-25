from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class Kit(db.Model):
    __tablename__ = 'kits'
    id = db.Column(db.Integer, primary_key=True)
    mac_address = db.Column(db.String(50), unique=True, nullable=False)
    name = db.Column(db.String(100), nullable=False)
    
    # Relationships
    sensor_data = db.relationship('SensorData', backref='kit', lazy=True)

class SensorData(db.Model):
    __tablename__ = 'sensor_data'
    id = db.Column(db.Integer, primary_key=True)
    kit_id = db.Column(db.Integer, db.ForeignKey('kits.id'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Sensor metrics
    ph = db.Column(db.Float, nullable=False)
    dissolved_oxygen = db.Column(db.Float, nullable=False) # mg/L
    tds = db.Column(db.Float, nullable=False) # Total Dissolved Solids, ppm
    turbidity = db.Column(db.Float, nullable=False) # NTU
    ammonia = db.Column(db.Float, nullable=False) # mg/L
    humidity = db.Column(db.Float, nullable=False) # Percentage (%) - ambient
    temperature = db.Column(db.Float, nullable=False) # Celsius (water temp)
    water_level = db.Column(db.Float, nullable=False) # Percentage (%)
