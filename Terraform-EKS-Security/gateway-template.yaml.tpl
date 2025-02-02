apiVersion: apps/v1
kind: Deployment
metadata:
  name: aline-gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: aline-gateway
  template:
    metadata:
      labels:
        app: aline-gateway
    spec:
      containers:
        - name: aline-gateway
          imagePullPolicy: IfNotPresent
          image: 767397723308.dkr.ecr.us-east-1.amazonaws.com/aline-financial-mm:aline_gateway-v10
          ports:
            - containerPort: 8080
          env:
            - name: APP_SERVICE_HOST
              valueFrom:
                secretKeyRef:
                  name: gateway-secrets
                  key: APP_SERVICE_HOST
            - name: PORTAL_LANDING
              valueFrom:
                secretKeyRef:
                  name: gateway-secrets
                  key: PORTAL_LANDING
            - name: PORTAL_DASHBOARD
              valueFrom:
                secretKeyRef:
                  name: gateway-secrets
                  key: PORTAL_DASHBOARD
            - name: PORTAL_ADMIN
              valueFrom:
                secretKeyRef:
                  name: gateway-secrets
                  key: PORTAL_ADMIN

---

apiVersion: v1
kind: Service
metadata:
  name: aline-gateway
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    service.beta.kubernetes.io/aws-load-balancer-subnets: ${subnet_ids}
spec:
  selector:
    app: aline-gateway
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
  type: LoadBalancer
