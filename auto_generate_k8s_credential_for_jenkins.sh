#!/bin/bash

# === [CONFIG] ===
OUTPUT_PATH=./minikube-kubeconfig.yaml
PROFILE=minikube

# === [Resolve paths] ===
CA_PATH="$HOME/.minikube/ca.crt"
CERT_PATH="$HOME/.minikube/profiles/$PROFILE/client.crt"
KEY_PATH="$HOME/.minikube/profiles/$PROFILE/client.key"

# === [Verify required files] ===
for f in "$CA_PATH" "$CERT_PATH" "$KEY_PATH"; do
  if [ ! -f "$f" ]; then
    echo "❌ Missing required file: $f"
    exit 1
  fi
done

# === [Base64 encode certificates] ===
CA=$(base64 < "$CA_PATH" | tr -d '\n')
CRT=$(base64 < "$CERT_PATH" | tr -d '\n')
KEY=$(base64 < "$KEY_PATH" | tr -d '\n')

# === [Get Minikube IP] ===
API_IP=$(minikube ip)
API_PORT=8443   # default API Server port，if you did port-forward，remember modify this line

# === [Write kubeconfig YAML] ===
cat <<EOF > "$OUTPUT_PATH"
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: https://$API_IP:$API_PORT
    certificate-authority-data: $CA
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube
  name: minikube
current-context: minikube
users:
- name: minikube
  user:
    client-certificate-data: $CRT
    client-key-data: $KEY
EOF

echo "✅ kubeconfig with embedded credentials saved to: $OUTPUT_PATH"
