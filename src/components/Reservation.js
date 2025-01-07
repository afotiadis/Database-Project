import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

function Reservation() {
    const { id } = useParams(); // Get the reservation ID from the URL
    const [reservation, setReservation] = useState(null);

    useEffect(() => {
        fetch(`http://localhost:8080/reservation/${id}`)
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Failed to fetch the reservation details');
                }
                return response.json();
            })
            .then((data) => setReservation(data))
            .catch((error) => console.error('Error fetching the reservation:', error));
    }, [id]);

    if (!reservation) {
        return <div>Loading...</div>;
    }

    // Convert the start and end time to Date objects and calculate the time parked
    const ReservationStartTime = new Date(reservation.start_time);
    const ReservationEndTime = new Date(reservation.end_time);
    const timeParked = Math.round((ReservationEndTime - ReservationStartTime) / 60000);
    const hours = Math.floor(timeParked / 60);
    const minutes = timeParked % 60;

    return (
        <div className="container mt-5">
            <div className="card bg-primary text-white shadow p-3">
                <h2 className="text-center display-4">Reservation Details</h2>
                <div className="card-body">
                    <div className="row">
                        <div className="col-12 text-center">
                            <h5 className="card-title display-5">Address: {reservation.address}</h5>
                        </div>
                    </div>
                    <div className="row mt-3">
                        <div className="col-md-6 text-center mt-4 mb-4">
                            <p className="card-text display-6">Reservation ID: {reservation.reservation_id}</p>
                            <p className="card-text display-6">Status: {reservation.status}</p>
                        </div>
                        <div className="col-md-6 text-center mt-4 mb-4">
                            <p className="card-text display-6">Start time: {ReservationStartTime.toLocaleString()}</p>
                            <p className="card-text display-6">End time: {ReservationEndTime.toLocaleString()}</p>
                        </div>
                        <div className="row">
                        <div className="col-12 text-center">
                            <p className="card-text display-6">Time Parked: {hours} hours and {minutes} minutes</p>
                        </div>
                    </div>
                    </div>
                    
                </div>
            </div>
        </div>
    );
}

export default Reservation;
