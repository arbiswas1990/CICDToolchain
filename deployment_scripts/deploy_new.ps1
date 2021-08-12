Set-Content -Path deployment-new.yaml -Value @"
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

kubectl apply -f deployment-new.yaml
