import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';


function Spot() {
    const { id } = useParams(); // Get the spot ID from the URL
    const [spot, setSpot] = useState(null);

    useEffect(() => {
        fetch(`${process.env.REACT_APP_SERVER_URL}/spot/${id}`)
            .then((response) => {
                if (!response.ok) {
                    throw new Error('Failed to fetch the spot details');
                }
                return response.json();
            })
            .then((data) => setSpot(data))
            .catch((error) => console.error('Error fetching the spot:', error));
    }, [id]);

    if (!spot) {
        return <div>Loading...</div>;
    }

    return (
        <div className="container mt-5">
            <div className="card bg-primary text-white shadow p-3">
                <h2 className="text-center display-4">Spot Details</h2>
                <div className="card-body">
                    <div className="row">
                        <div className="col-12 text-center">
                            <h5 className="card-title display-5">Address: {spot.address}</h5>
                        </div>
                    </div>
                    <div className="row mt-3">
                        <div className="col-md-6 text-center mt-4 mb-4">
                            <p className="card-text display-6">Spot ID: {spot.spot_id}</p>
                            <p className="card-text display-6">
                                <strong>Type:</strong> {spot.type}
                            </p>
                        </div>
                        <div className="col-md-6 text-center mt-4 mb-4">
                            <p className="card-text display-6">
                                <strong>Vehicles supported:</strong> No info
                            </p>
                            <p className="card-text display-6">
                                <strong>Charger Available:</strong> {spot.has_charger ? 'Yes' : 'No'}
                            </p>
                        </div>
                    </div>
                    <div className="row mt-3">
                        <div className="col-12 text-center">
                            <button
                                className="btn btn-light btn-lg"
                                onClick={() => window.location.href = `/new-reservation?spot_id=${spot.spot_id}`}
                            >
                               <strong> Make a Reservation</strong>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Spot;
