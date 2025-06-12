# demo_jenkins_k8s
# 🚀 macOS Kubernetes 本地開發環境建立教學

---

## 🗭 前言

| 工具           | 角色                        | 你會用來做什麼                                   |
| ------------ | ------------------------- | ----------------------------------------- |
| **minikube** | 本機 Kubernetes cluster 啟動器 | 啟動、建立本機 K8s cluster                       |
| **kubectl**  | Kubernetes CLI            | 操作 Pods / Services / Deployments 等 K8s 資源 |
| **k9s**      | 終端視覺化 UI 操作器              | 可視化瀏覽 K8s 資源與狀態                           |

---

## 🛠️ 系統需求

* 安裝好 [Homebrew](https://brew.sh/)

---

## 🚜 安裝 `minikube`

```bash
brew install minikube
```

啟動 cluster:

```bash
minikube start --driver=docker
```

確認 cluster 狀態:

```bash
minikube status
```

---

## 👛 安裝 `kubectl`

```bash
brew install kubectl
```

檢查版本:

```bash
kubectl version --client
```

---

## 🐣 安裝 `k9s`

```bash
brew install k9s
```

啟動終端 UI:

```bash
k9s
```

---

## ✅ 驗證環境

建立 test deployment:

```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
minikube service hello-minikube
```

---

## 🔄 工具關係圖

| 工具       | 功能                   | 與其他關聯               |
| -------- | -------------------- | ------------------- |
| minikube | 啟動 local K8s cluster | kubectl / k9s 供操作   |
| kubectl  | CLI 控制端              | 對 cluster 下 command |
| k9s      | UI-like 終端操作         | 使用 kubeconfig 連線    |

---

## 📁 打包 Docker image

```bash
eval $(minikube docker-env)
docker build -t automation-image:latest .
```

---

## 🚀 啟動 Jenkins

```bash
docker compose up -d
```

第一次啟動手動取得 admin password:

![password](doc/default_password.png)

---

## 安裝 Jenkins Plugin

* 前往 `Manage Jenkins > Plugin > Available`
* 安裝:

  * `Pipeline`
  * `Kubernetes`
* 重新啟動 Jenkins

---

## 生成 k8s Credential

```bash
./auto_generate_k8s_credential_for_jenkins.sh
```

會產生:

* `minikube-kubeconfig.yaml`

---

## 上傳 Credential 至 Jenkins

`Manage Jenkins > Credentials > Global > Add kubeconfig`

上傳 `minikube-kubeconfig.yaml`

![credential](doc/credential.png)

---

## 設定 Kubernetes Cloud 連線

`Manage Jenkins > Cloud > K8S > Configure`

* Jenkins URL: `http://host.docker.internal:8080`
* Tunnel: `host.docker.internal:50000`

![k8s-setting](doc/k8s_setting.png)

---

## 新增 Pipeline Job

* New Item > 選 pipeline > 填寫 script
* 添加 `DEBUG_MODE` bool 參數

![param](doc/parameter_setting.png)
![script](doc/pipeline.png)

---

## 執行 job

* 啟動 job
* 會啟用 K8s pod 執行 Python script

![log](doc/jenkins_log.png)

如果 DEBUG\_MODE 為 ON 會轉入 `tail -f /dev/null` 保持存機

可用 `k9s` 看到 Pod:

![pod](doc/k9s_pod.png)

與 container 資訊:

![containers](doc/k9s_containers.png)

記得要手動 Cancel job 來結束執行

----

# 🚀 Local Kubernetes Development on macOS

## Create your own K8s playground using `kubectl`, `minikube`, and `k9s`

---

## 🗭 Introduction

| Tool         | Role                            | What it does                                          |
| ------------ | ------------------------------- | ----------------------------------------------------- |
| **minikube** | Local Kubernetes Cluster Engine | Starts and manages a K8s cluster locally              |
| **kubectl**  | Kubernetes CLI                  | Controls resources like Pods / Services / Deployments |
| **k9s**      | Terminal UI Tool                | Visualizes and monitors K8s resources in real-time    |

---

## 🛠️ System Requirements

* [Homebrew](https://brew.sh/) must be installed

---

## 🚜 Install `minikube`

```bash
brew install minikube
```

Start the cluster:

```bash
minikube start --driver=docker
```

Check cluster status:

```bash
minikube status
```

---

## 👛 Install `kubectl`

```bash
brew install kubectl
```

Verify:

```bash
kubectl version --client
```

---

## 🐣 Install `k9s`

```bash
brew install k9s
```

Launch the terminal UI:

```bash
k9s
```

---

## ✅ Verify Everything Works

Create a test deployment:

```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
minikube service hello-minikube
```

---

## 🔄 Tools Relationship Overview

| Tool     | Role                  | Related To                     |
| -------- | --------------------- | ------------------------------ |
| minikube | Runs local Kubernetes | Operated by kubectl & k9s      |
| kubectl  | CLI for managing K8s  | Sends commands to the cluster  |
| k9s      | Terminal-based K8s UI | Uses kubeconfig for connection |

---

## 📁 Build Docker Image

```bash
eval $(minikube docker-env)
docker build -t automation-image:latest .
```

---

## 🚀 Launch Jenkins

```bash
docker compose up -d
```

First-time login requires checking container logs for password:

![password](doc/default_password.png)

---

## Install Required Jenkins Plugins

* Go to `Manage Jenkins > Plugin > Available`
* Install:

  * `Pipeline`
  * `Kubernetes`
* Restart Jenkins

---

## Generate K8s Credential

```bash
./auto_generate_k8s_credential_for_jenkins.sh
```

This generates:

* `minikube-kubeconfig.yaml`

---

## Upload Kubeconfig to Jenkins

`Manage Jenkins > Credentials > Global > Add kubeconfig`

Upload `minikube-kubeconfig.yaml`

![credential](doc/credential.png)

---

## Configure Kubernetes Cloud in Jenkins

`Manage Jenkins > Cloud > K8S > Configure`

* Jenkins URL: `http://host.docker.internal:8080`
* Tunnel: `host.docker.internal:50000`

![k8s-setting](doc/k8s_setting.png)

---

## Create Pipeline Job

* New Item > Choose `pipeline`
* Add a bool param `DEBUG_MODE`
* Paste your pipeline script

![param](doc/parameter_setting.png)
![script](doc/pipeline.png)

---

## Run the Job

* Run the job from Jenkins UI
* It should spin up a K8s pod to run Python script

![log](doc/jenkins_log.png)

If `DEBUG_MODE` is ON, it will run `tail -f /dev/null` to keep the container alive.

Use `k9s` to see running pods:

![pod](doc/k9s_pod.png)

And containers inside:

![containers](doc/k9s_containers.png)

To stop, manually cancel the job in Jenkins.
