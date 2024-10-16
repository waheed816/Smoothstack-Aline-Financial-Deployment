// export const environment = {
//   production: true,
//   application: {
//     api: 'https://api.alinefinancial.com/api',
//     landingPortal: 'https://alinefinancial.com'
//   }
// };

// export const environment = {
//   production: true,
//   application: {
//     api: 'http://localhost:8080/api',
//     landingPortal: 'http://localhost:3007'
//   }
// };

export const environment = {
  production: true,
  application: {
    api: 'http://k8s-default-alinegat-8f9052450a-8c410573208455ad.elb.us-east-1.amazonaws.com:8080/api',
    landingPortal: 'http://k8s-ingressmm-795bef71bb-1679240362.us-east-1.elb.amazonaws.com:3007'
  }
};
