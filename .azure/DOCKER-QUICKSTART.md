# 🐳 Docker Quick Start Guide - resttemplateserver

## 1️⃣ Build the Docker Image

```bash
# Navigate to project directory
cd d:\GitHub\resttemplateserver

# Build the image
docker build -t resttemplateserver:1.0 .

# Verify build
docker images | grep resttemplateserver
```

**Expected Output:**
```
REPOSITORY              TAG     IMAGE ID     CREATED         SIZE
resttemplateserver      1.0     abc123def    10 seconds ago   180MB
```

---

## 2️⃣ Run with Docker (Requires MySQL)

### Option A: With External MySQL
```bash
# Run the container
docker run -d \
  --name resttemplateserver \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://your-mysql-host:3306/bookdb \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=123456 \
  resttemplateserver:1.0

# Check logs
docker logs -f resttemplateserver

# Test the API
curl http://localhost:8080/api/books
```

### Option B: With Docker Compose (Includes MySQL)
```bash
# Run both services
docker-compose up -d

# View logs
docker-compose logs -f resttemplateserver

# Stop
docker-compose down
```

---

## 3️⃣ Verify Container Health

```bash
# Check status
docker ps -f "name=resttemplateserver"

# View logs
docker logs resttemplateserver

# Check health
docker inspect resttemplateserver --format='{{.State.Health.Status}}'

# Test API
curl http://localhost:8080/actuator/health
```

---

## 4️⃣ Scan for Vulnerabilities

```bash
docker scan resttemplateserver:1.0
```

---

## 5️⃣ Push to Registry (Azure Container Registry)

```bash
# Login to ACR
az acr login --name myregistry

# Tag image
docker tag resttemplateserver:1.0 myregistry.azurecr.io/resttemplateserver:1.0

# Push
docker push myregistry.azurecr.io/resttemplateserver:1.0
```

---

## ✅ Troubleshooting

| Issue | Solution |
|-------|----------|
| **Port already in use** | `docker run -p 8081:8080 ...` or `docker stop <container-id>` |
| **MySQL connection fails** | Verify MySQL is running and accessible |
| **Build fails** | Run `docker build --progress=plain -t ...` for detailed output |
| **Container exits** | Check logs: `docker logs <container-id>` |

---

## 📊 Image Size Breakdown

```
Base Image (Eclipse Temurin JRE)      : ~120MB
Application JAR                        : ~35MB
Alpine Linux                           : ~6MB
Other dependencies & layers            : ~20MB
─────────────────────────────────────────────
Total                                  : ~180MB
```

---

## 🔐 Security Features

✅ Non-root user (UID 1000)  
✅ Alpine base image (minimal attack surface)  
✅ Health check endpoint  
✅ `.dockerignore` for build optimization  
✅ Optimized JVM for containers  

---

## 📝 Key Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Production-grade multi-stage build |
| `.dockerignore` | Build context optimization |
| `pom.xml` | Java 25 configuration |
| `application.properties` | Environment-based config |

---

**Last Updated:** 2026-06-23  
**Status:** ✅ Ready to Build
