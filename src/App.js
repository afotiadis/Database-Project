import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import ParkingSpots from './components/ParkingSpots';
import Reservations from './components/Reservations';
import NewReservation from './components/NewReservation';
import Spot from './components/Spot';
import Reservation from './components/Reservation';
import './styles/custom.scss';

function App() {
  const [activeLink, setActiveLink] = React.useState(window.location.pathname);

  return (
    <Router>
      <div className="d-flex min-vh-100 bg-dark text-light">
        {/* Sidebar */}
        <nav className="text-light bg-primary vh-100 p-3 position-fixed" style={{ width: '250px', height: '100vh' }}>
          <h2 className="text-center">Curbsprings DB</h2>
          <ul className="nav nav-pills flex-column mt-4">
            <li className="nav-item mb-3">
              <Link 
                to="/" 
                className={`nav-link ${activeLink === '/' ? 'bg-secondary text-dark' : 'bg-primary text-light'} text-center fw-bold`}
                onClick={() => setActiveLink('/')}
              >
                Parking Spots
              </Link>
            </li>
            <li className="nav-item mb-3">
              <Link 
                to="/reservations" 
                className={`nav-link ${activeLink === '/reservations' ? 'bg-secondary text-dark' : 'bg-primary text-light'} text-center fw-bold`}
                onClick={() => setActiveLink('/reservations')}
              >
                Reservations
              </Link>
            </li>
            <li className="nav-item mb-3">
              <Link 
                to="/new-reservation" 
                className={`nav-link ${activeLink === '/new-reservation' ? 'bg-secondary text-dark' : 'bg-primary text-light'} text-center fw-bold`}
                onClick={() => setActiveLink('/new-reservation')}
              >
                New Reservation
              </Link>
            </li>
          </ul>
        </nav>
        <div className="flex-grow-1 p-4" style={{ marginLeft: '250px' }}>
          <Routes>
            <Route path="/" element={<ParkingSpots />} />
            <Route path="/spot/:id" element={<Spot />} />
            <Route path="/reservations" element={<Reservations />} />
            <Route path="/reservations/:id" element={<Reservation />} />
            <Route path="/new-reservation" element={<NewReservation />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;

