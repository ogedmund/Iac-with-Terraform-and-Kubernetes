# Kubernetes Overview
[Kubernetes](https://kubernetes.io/) is an open source container management system for deploying, scaling, and managing containerized applications. Kubernetes is built by Google based on their internal proprietary container management systems (Borg and Omega). Kubernetes provides a cloud agnostic platform to deploy your containerized applications with built in support for common operational tasks such as replication, autoscaling, self-healing, and rolling deployments.

You can learn more about Kubernetes from the [official documentation](https://kubernetes.io/docs/home/)

Deploying ***Kubernetes*** results in a Kubernetes cluster, which is a set of machines that consist of a control plane and worker nodes. The control plane manages the worker nodes and the containerized applications in Pods which run on the worker nodes. Production grade clusters usually have the control plane running on multiple machines, managing many running worker nodes for fault tolerance and high availability [6]. The control plane and the worker nodes consist of various key components necessary for the complete operation of a Kubernetes cluster. 

The control plane components include:

- ***Kube-apiserver***: This component is the front end of the control plane exposing the Kubernetes API. It is designed to scale horizontally by deploying more instances and balancing traffic between those instances.
- Etcd: This component is a highly available and consistent key-value store responsible for storing Kubernetes’ cluster data. The data in the etcd is usually encrypted at rest for extra security.
- ***Kube-scheduler***: This component monitors and selects nodes for newly created Pods to run on. The factors for scheduling decisions include resource requirements, hardware/software/policy constraints, data locality, and other important factors.
- ***Kube-controller-manager***: This component runs a set of controller processes responsible for noticing and responding to nodes that go down, creating Pods to run certain jobs to completion, creating default accounts for new namespaces, etc.
- ***Cloud-controller-manager***: This is an optional component that embeds cloud-specific control logic and allows you to link your cluster to your Cloud provider’s API. It runs controllers that are specific to the particular Cloud provider. A locally run Kubernetes cluster does not have this component present.

The worker node components include:

- ***Kubelet***: This component is an agent that runs on each node in a cluster and ensures that containers are healthy and running in a Pod.
- ***Kube-proxy***: This component is a networking agent that runs on each node and implements part of the Kubernetes Service concept to allow networking to your Pods from inside or outside the cluster.
- ***Container runtime***: This is the fundamental component that is responsible for managing the execution and life cycle of containers within the Kubernetes environment.
- ***Container Resource Monitoring***: This component records generic time-series metrics about containers in a central database and provides a UI for browsing data.
- ***DNS***: Cluster DNS is a DNS server that is a necessary add-on in addition to other DNS servers that serve DNS records for Kubernetes services.
- ***Network Plugins***:  These are software components that implement the container network interface (CNI) specification that is responsible for allocating IP addresses to Pods enabling them to communicate with each other within the cluster.

While this is not an exhaustive list of all possible Kubernetes components, they are the essential components, and they communicate securely with each other through signed TLS certificates to ensure the full functionality of Kubernetes.


![See K8s Architectural Diagram](https://github.com/ogedmund/Iac-with-Terraform-and-Kubernetes/blob/main/kubernetes/K8s.png?raw=true)



# How do you run applications on Kubernetes?
There are three different ways you can schedule your application on a Kubernetes cluster. In all three, your application Docker containers are packaged as a [Pod](https://kubernetes.io/docs/concepts/workloads/pods/), which are the smallest deployable unit in Kubernetes, and represent one or more Docker containers that are tightly coupled. Containers in a Pod share certain elements of the kernel space that are traditionally isolated between containers, such as the network space (the containers both share an IP and thus the available ports are shared), IPC namespace, and PIDs in some cases.

Pods are considered to be relatively ephemeral disposable entities in the Kubernetes ecosystem. This is because Pods are designed to be mobile across the cluster so that you can design a scalable fault tolerant system. As such, Pods are generally scheduled with [Controllers](https://kubernetes.io/docs/concepts/workloads/pods/#pods-and-controllers) that manage the lifecycle of a Pod. Using Controllers, you can schedule your Pods as:

- Jobs, which are Pods with a controller that will guarantee the Pods run to completion.
- Deployments behind a Service, which are Pods with a controller that implement lifecycle rules to provide replication and self-healing capabilities. Deployments will automatically reprovision failed Pods, or migrate Pods to healthy nodes off of failed nodes. A Service constructs a consistent endpoint that can be used to access the Deployment.
- Daemon Sets, which are Pods that are scheduled on all worker nodes. Daemon Sets schedule exactly one instance of a Pod on each node. Like Deployments, Daemon Sets will reprovision failed Pods and schedule new ones automatically on new nodes that join the cluster.


