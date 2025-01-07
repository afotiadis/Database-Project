import React, { useEffect, useState } from 'react';


function Reservations() {
  const [reservations, setReservations] = useState([]);

  useEffect(() => {
    fetch(`${process.env.REACT_APP_SERVER_URL}/reservation`)
      .then((response) => response.json())
      .then((data) => setReservations(data))
      .catch((error) => console.error('Error fetching reservations:', error));
  }, []);

  return (
    <div>
      <h1 className="text-center mb-4">Reservations</h1>
      <div className="row">
      {reservations.map((reservation) => {
        const startTime = new Date(reservation.start_time);
        const endTime = new Date(reservation.end_time);
        const timeParked = Math.round((endTime - startTime) / 60000);
        const hours = Math.floor(timeParked / 60);
        const minutes = timeParked % 60;

        return (
        <div className="col-md-4 mb-4" key={reservation.reservation_id}>
          <div className="card bg-primary text-white"
          style={{ height: '100%', transition: 'transform 0.3s' }}
          onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.03)'}
          onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}>
          <div className="card-body" onClick={() => window.location.href = `/reservations/${reservation.reservation_id}`}>
            <h5 className="card-title">{reservation.address}</h5>
            
            <p className="card-text">
            <strong>From:</strong> {startTime.toLocaleString()}
            </p>
            <p className="card-text">
            <strong>To:</strong> {endTime.toLocaleString()}
            </p>
            <p className="card-text">
            <strong>Time Parked:</strong> {hours} hours and {minutes} minutes
            </p>
          </div>
          </div>
        </div>
        );
      })}
      </div>
    </div>
    );
}

export default Reservations;
