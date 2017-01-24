# creates a webservice..underwater it will create a public IP and link it to the loadbalancer
kubectl expose deployment redis-webapp --port=8080
