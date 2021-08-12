Set-Content -Path app-canary.yaml -Value @"
apiVersion: flagger.app/v1beta1
kind: Canary
metadata:
  name: #{PackageName}
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: #{PackageName}
  progressDeadlineSeconds: 60
  service:
    port: 8080
    gateways:
    - app
    hosts:
    - "*"
  analysis:
    interval: 30s
    threshold: 10
    maxWeight: 75
    stepWeight: 25
    metrics:
    - name: requst-success-rate
      threshold: 99
      interval: 30s
"@



Set-Content -Path deployment-old.yaml -Value @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: #{PackageName}
  labels:
    app: demo-#{PackageName}
spec:
  selector:
    matchLabels:
      app: demo-#{PackageName}
  template:
       labels:
         app: demo-#{PackageName}
    spec:
      containers:
        - name: #{PackageName}
          image: selfuseinstance.jfrog.io/default-docker-virtual/#{PackageName}:#{packageVersion}
          livenessProbe:
             httpGet:
                path: /version
                port: 8080
          ports:
            - containerPort: 8080
"@

Set-Content -Path gateway.yaml -Value @"
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: #{PackageName}
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
"@

kubectl apply -f deployment-old.yaml -f gateway.yaml -f app-canary.yaml