import React, { useEffect, useState, useRef } from 'react';
import { createPopper } from '@popperjs/core';


function ParkingSpots() {
  const [spots, setSpots] = useState([]);
  const tooltipRef = useRef(null); // Tooltip reference
  const currentImgRef = useRef(null); // Reference to the currently hovered image

  useEffect(() => {
    fetch(`${process.env.REACT_APP_SERVER_URL}/spot`)
      .then((response) => response.json())
      .then((data) => setSpots(data))
      .catch((error) => console.error('Error fetching parking spots:', error));
  }, []);
    
  const showTooltip = (imgRef) => {
    if (tooltipRef.current) {
      currentImgRef.current = imgRef; // Set the current image reference
      tooltipRef.current.style.display = 'block';

      // Initialize Popper.js for the tooltip positioning
      createPopper(imgRef, tooltipRef.current, {
        placement: 'top',
        modifiers: [
          {
            name: 'offset',
            options: {
              offset: [0, 8], // Slight offset for better visibility
            },
          },
        ],
      });
    }
  };

  const hideTooltip = () => {
    if (tooltipRef.current) {
      tooltipRef.current.style.display = 'none';
    }
  };

  return (
    <div>
      <h1 className="text-center mb-4">Parking Spots</h1>
      <div className="row">
        {spots.map((spot) => (
          <div className="col-md-4 mb-4 shadow-m" key={spot.id}>
            <div
              className={`card ${spot.available ? 'bg-primary' : 'bg-secondary'} text-white position-relative`}
              style={{
                height: '11rem',
                transition: 'transform 0.3s',
                opacity: spot.available ? 1 : 0.5,
                pointerEvents: spot.available ? 'auto' : 'none', // Make it unclickable if not available
              }}
              onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.03)'}
              onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}
            >
              <div className="card-body d-flex flex-column"
                onClick={() => spot.available && (window.location.href = `/spot/${spot.spot_id}`)}>
                <h5 className="card-title">{spot.address}</h5>
                <p className="card-text">Spot ID: {spot.spot_id}</p>
                <p className="card-text">
                  <strong>Type:</strong> {spot.type}
                </p>
                <p className="card-text">
                  <strong>Spot available:</strong> {spot.available ? 'Yes' : 'No'}
                </p>
                {spot.has_charger ? (
                  <>
                    <img
                      src={require('../images/charger.png')}
                      alt="Charger"
                      ref={(ref) => (currentImgRef.current = ref)}
                      onMouseEnter={(e) => showTooltip(e.currentTarget)}
                      onMouseLeave={hideTooltip}
                      style={{
                        position: 'absolute',
                        bottom: '25px',
                        right: '10px',
                        width: '40px',
                        height: 'auto',
                        cursor: 'pointer',
                      }}
                    />
                  </>
                ):null}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Tooltip Element */}
      <div
        ref={tooltipRef}
        style={{
          display: 'none',
          background: 'black',
          color: 'white',
          padding: '5px 10px',
          borderRadius: '5px',
          fontSize: '16px',
          zIndex: '1000',
        }}
      >
        Charger Available!
      </div>
    </div>
  );
}

export default ParkingSpots;
