import firebase from "firebase/compat/app";
import "firebase/compat/auth";
import { useSelector } from "react-redux";
import Loader from "../../components/loader/Loader";
import { getMessaging, getToken, onMessage } from "firebase/messaging";

const FirebaseData = () => {

  const setting = useSelector((state) => state.setting);


  if (setting.setting === null) {
    return <Loader screen='full' />;
  }

  const apiKey = setting.setting && setting.setting.firebase.apiKey;
  const authDomain = setting.setting && setting.setting.firebase.authDomain;
  const projectId = setting.setting && setting.setting.firebase.projectId;
  const storageBucket = setting.setting && setting.setting.firebase.storageBucket;
  const messagingSenderId = setting.setting && setting.setting.firebase.messagingSenderId;
  const appId = setting.setting && setting.setting.firebase.appId;
  const measurementId = setting.setting && setting.setting.firebase.measurementId;


  const firebaseConfig = {
    apiKey: apiKey,
    authDomain: authDomain,
    projectId: projectId,
    storageBucket: storageBucket,
    messagingSenderId: messagingSenderId,
    appId: appId,
    measurementId: measurementId,
  };

  if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
  } else {
    firebase.app();
  }

  const auth = firebase.auth();
  // const messaging = getMessaging(firebase.app());
  
  return { auth, firebase };
};

export default FirebaseData;
// export const FcmToken = (setTokenFound) => {
//   // const {messaging} = FirebaseData()
//   // return getToken(messaging, {vapidKey: 'BEi3E10PuFA0QiE3VyZcGCIWSJVxAT3iYHDqq9U8RPF3d43sZZkRnuTzJAZFk3UZDa2zDcrwMEV41cRjtVs8lLc'}).then((currentToken) => {
//   //   if (currentToken) {
//   //     console.log(currentToken)
//   //     setTokenFound(true);
//   //     // Track the token -> client mapping, by sending to backend server
//   //     // show on the UI that permission is secured
//   //   } else {
//   //     console.log('No registration token available. Request permission to generate one.');
//   //     setTokenFound(false);
      
//   //   }
//   // }).catch((err) => {
//   //   console.log('An error occurred while retrieving token. ', err);
//   //   // catch error while creating client token
//   // });
//   return "hi"
// }
// export const onMessageListener = () =>{
  
//   // new Promise((resolve) => {
//   //   const {messaging} = FirebaseData()
//   //   onMessage(messaging, (payload) => {
//   //     resolve(payload);
//   //   });
//   // });
// }