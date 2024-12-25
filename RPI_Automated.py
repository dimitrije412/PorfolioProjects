import time
import RPi.GPIO as GPIO

#  nameštanje GPIO 
GPIO.setmode(GPIO.BOARD)

# senzor vlažnosti 
MOISTURE_PIN = 29
GPIO.setup(MOISTURE_PIN, GPIO.IN)

# pumpa za vodu
PUMP_PIN = 35
GPIO.setup(PUMP_PIN, GPIO.OUT)

def water_plants():
    print("zalivanje...")
    GPIO.output(PUMP_PIN, GPIO.HIGH)    # Aktiviraj pumpu

def stop_watering():
    print("zaustavljanje...")
    GPIO.output(PUMP_PIN, GPIO.LOW)     # Deaktiviraj pumpu

try:
    while True:
        # Pročitaj nivo vlažnosti
        moisture_level = GPIO.input(MOISTURE_PIN)

        if moisture_level == GPIO.LOW:  # Zemljište suvo
            if GPIO.input(PUMP_PIN) == GPIO.LOW:  # Proveri da li je pumpa nije već pokrenuta
                water_plants()
        elif moisture_level == GPIO.HIGH:  # Zemljište vlažno
            if GPIO.input(PUMP_PIN) == GPIO.HIGH:  # Proveri da li je pumpa pokrenuta
                stop_watering()

        time.sleep(1)   # Interval između provera vlažnosti koji može da se menja 

except KeyboardInterrupt:
    print("Zaustavljanje programa.")

finally:
    # cleanup koji ide uz try i except blokove, koji se uvek izvršava 
    GPIO.cleanup()
