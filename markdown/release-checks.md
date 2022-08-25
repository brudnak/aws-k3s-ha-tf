# Hosted / Tenant Rancher Checks

#### [back to main markdown](../README.md)

**Checks on**

<hr>

- [ ] Validation of Rancher on Rancher
- [ ] Validating upgrade of tenant clusters to current rancher RC
- [ ] Validate upgrade of hosted rancher

## Fresh Install Checks

- [ ] deploy hosted rancher using latest RC
- [ ] Deploy tenant cluster using latest RC
- Following checks can be done:
    - [ ] Deploy a bunch of downstream clusters including - GKE/EKS/AKS v2 clusters
    - [ ] Test anything specific to any fixed issues applicable for Hosted rancher setup - example: EKS/GKE/AKS osted clusters/Restricted Admin changes, etc
    - [ ] Deploy monitoring charts on the downstream clusters and rancher - hosted and tenant - local clusters
    - [ ] Check Hosted rancher logs for anything abnormal
    - [ ] Check tenant rancher server logs for anything abnormal


## Upgrade Checks

- [ ] Deploy last stable release example - v2.5.9 - Hosted rancher
- [ ] Deploy tenant on v2.5.9 k3s local cluster + Rancher
- [ ] Deploy monitoring on the local clusters
- [ ] For a 2.5.9 to 2.6 upgrade, the hosted rancher has to be upgraded first and then the Tenant downstream cluster
- [ ] Same checks as listed above (fresh install checks) can be done. Including preupgrade and post upgrade checks