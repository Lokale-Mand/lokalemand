import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import store from './model/store';
import { Provider } from 'react-redux';
import {Persiststore} from './model/store';
import { PersistGate } from 'redux-persist/integration/react';
import { BrowserRouter } from 'react-router-dom';
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";



const root = ReactDOM.createRoot(document.getElementById('root'));

root.render(
      <BrowserRouter>
        <Provider store={store}>
        <PersistGate loading={null} persistor={Persiststore}>
          <App />
        </PersistGate>
        </Provider>
      </BrowserRouter>
);

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/firebase-messaging-sw.js').then((registration) => {

    }).catch((error) => {

    });
  });
}

