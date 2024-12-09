import React, { useState, useEffect } from 'react';

function NewReservation() {
  const [spot, setSpot] = useState('');
  const [startDatetime, setStartDatetime] = useState('');
  const [endDatetime, setEndDatetime] = useState('');
  const [licensePlate, setLicensePlate] = useState('');
  const defaultLicensePlate = 'ΚΒΧ5686';

  // If attribute spot_id is present in the URL, set the spot state
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const spotId = params.get('spot_id');
    if (spotId) {
      setSpot(spotId);
    }
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    
    // Format datetime to SQL datetime format
    const formatToSQLDatetime = (datetime) => {
      const date = new Date(datetime);
      return date.toISOString().slice(0, 19).replace('T', ' ');
    };

    // If licensePlate is empty, use defaultLicensePlate
    const finalLicensePlate = licensePlate || defaultLicensePlate;
    
    const newReservation = {
      spot_id: parseInt(spot),
      license_plate: finalLicensePlate,
      start_time: formatToSQLDatetime(startDatetime),
      end_time: formatToSQLDatetime(endDatetime)
    };

    console.log(newReservation);

    fetch('http://localhost:8080/reservation', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newReservation),
    })
      .then((response) => {
        console.log(response);
        if (response.status === 201) return response.json();
        throw new Error('Failed to create reservation');
      })
      .then((data) => alert(`Reservation created: ${JSON.stringify(data)}`))
      .catch((error) => console.error('Error:', error));
  };

  return (
    <div>
      <h1 className="text-center mb-4">New Reservation</h1>
      <form className="bg-dark p-4 text-white rounded" onSubmit={handleSubmit}>
        <div className="mb-3">
          <label htmlFor="spot" className="form-label">Spot ID:</label>
          <input type="number" className="form-control" id="spot" placeholder="Enter Spot ID" value={spot} onChange={(e) => setSpot(e.target.value)} required />
        </div>
        <div className="mb-3">
          <label htmlFor="startDatetime" className="form-label">Start DateTime:</label>
          <input type="datetime-local" className="form-control" id="startDatetime" onFocus={(e) => e.target.showPicker()} value={startDatetime} onChange={(e) => setStartDatetime(e.target.value)} required />
        </div>
        <div className="mb-3">
          <label htmlFor="endDatetime" className="form-label">End DateTime:</label>
          <input type="datetime-local" className="form-control" id="endDatetime" onFocus={(e) => e.target.showPicker()} value={endDatetime} onChange={(e) => setEndDatetime(e.target.value)} required />
        </div>
        <div className="mb-3">
          <label htmlFor="licensePlate" className="form-label">License Plate:</label>
          <input type="text" className="form-control" id="licensePlate" placeholder="Enter License Plate" value={licensePlate || defaultLicensePlate} onChange={(e) => setLicensePlate(e.target.value)} required />
        </div>
        <button type="submit" className="btn btn-primary" onClick={handleSubmit}>Create Reservation</button>
      </form>
    </div>
  );
}

export default NewReservation;
