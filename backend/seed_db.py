from app import app, db
from models import Kit, SensorData
import random
from datetime import datetime, timedelta

def seed_database():
    with app.app_context():
        # Drop all tables and recreate them
        db.drop_all()
        db.create_all()

        print("Seeding database (Hardware side only since Auth is Supabase)...")

        # 1. Create a Kit
        kit1 = Kit(mac_address="00:1B:44:11:3A:B7", name="Main Tank Kit")
        kit2 = Kit(mac_address="00:1B:44:11:3A:C8", name="Secondary Tank Kit")
        db.session.add(kit1)
        db.session.add(kit2)
        db.session.commit()

        # 3. Create Sensor Data for Kit 1
        now = datetime.utcnow()
        for i in range(20):
            timestamp = now - timedelta(minutes=15 * i)
            data = SensorData(
                kit_id=kit1.id,
                timestamp=timestamp,
                ph=round(random.uniform(7.0, 7.5), 2),
                dissolved_oxygen=round(random.uniform(6.5, 8.0), 2),
                tds=round(random.uniform(300, 400), 2),
                turbidity=round(random.uniform(1.0, 5.0), 2),
                ammonia=round(random.uniform(0.01, 0.05), 3),
                humidity=round(random.uniform(50, 70), 1),
                temperature=round(random.uniform(24.0, 26.5), 1),
                water_level=round(random.uniform(90, 100), 1)
            )
            db.session.add(data)
            
        # Create Sensor Data for Kit 2
        for i in range(20):
            timestamp = now - timedelta(minutes=15 * i)
            data = SensorData(
                kit_id=kit2.id,
                timestamp=timestamp,
                ph=round(random.uniform(6.5, 6.8), 2),
                dissolved_oxygen=round(random.uniform(5.5, 6.5), 2),
                tds=round(random.uniform(150, 200), 2),
                turbidity=round(random.uniform(5.0, 10.0), 2),
                ammonia=round(random.uniform(0.05, 0.1), 3),
                humidity=round(random.uniform(40, 50), 1),
                temperature=round(random.uniform(22.0, 23.5), 1),
                water_level=round(random.uniform(70, 80), 1)
            )
            db.session.add(data)

        db.session.commit()
        print("Database seeded successfully with hardware telemetry for 2 kits!")
        print("Any new User signing up via Supabase using MAC: 00:1B:44:11:3A:B7 or 00:1B:44:11:3A:C8 will securely see this data.")

if __name__ == '__main__':
    seed_database()
