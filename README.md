# UK Weather Intelligence Platform

A production-grade real-time weather data engineering platform
built on Microsoft Azure, ingesting live sensor data from 10 UK
cities every 20 minutes with ML-powered temperature prediction.

---

## Architecture

---

## Tech Stack

| Layer | Technology |
|---|---|
| Infrastructure | Terraform, Azure Resource Manager |
| Orchestration | Azure Data Factory |
| Storage | ADLS Gen2, Delta Lake |
| Transformation | Azure Databricks, PySpark |
| Governance | Unity Catalog |
| ML Training | scikit-learn, MLflow, Azure ML |
| Serving | Azure Synapse Analytics Serverless SQL |
| Visualisation | Power BI |
| Security | Azure Key Vault, Managed Identity, OAuth2 |
| Version Control | GitHub, ADF Git integration, Databricks Repos |

---

## Data Sources

- **OpenWeatherMap API** (free tier — 1M calls/month)
- **Current weather endpoint**: `/data/2.5/weather`
- **Air quality endpoint**: `/data/2.5/air_pollution`
- **10 UK cities**: London, Manchester, Birmingham, Leeds,
  Glasgow, Liverpool, Edinburgh, Bristol, Cardiff, Newcastle

---

## Medallion Architecture

---

## ML Model Performance

Trained on 24-hour temperature prediction across 10 UK cities.

| Model | MAE | RMSE | R² |
|---|---|---|---|
| Linear Regression | 0.30°C | 0.40°C | 0.893 |
| Random Forest | 0.28°C | 0.42°C | 0.880 |
| **Gradient Boosting** | **0.21°C** | **0.33°C** | **0.926** |

Gradient Boosting selected as best model.
Key feature: `temperature_c` (96.9% importance) —
current temperature is the strongest predictor of
tomorrow's temperature (temporal autocorrelation).

---

## Pipeline Schedule

---

## Infrastructure (Terraform)

All Azure resources managed as Infrastructure as Code:

| Resource | Name | Region |
|---|---|---|
| Resource Group | uk-weather-dev | eastus |
| ADLS Gen2 | ukweatherstorage | eastus |
| ADF | uk-weather-adf | eastus |
| Key Vault | uk-weather-kv | eastus |
| Databricks | uk-weather-databricks | eastus |
| Synapse | uk-weather-synapse | uksouth |
| Azure ML | uk-weather-aml | uksouth |
| App Insights | uk-weather-appinsights | uksouth |

---

## Security

- API keys stored in Azure Key Vault (never in code)
- ADF authenticates to Key Vault via Managed Identity
- Databricks authenticates to Key Vault via secret scope
- ADF triggers Databricks via OAuth2 Service Principal
- All role assignments managed via Terraform RBAC

---

## Repository Structure

---

## Synapse SQL Views

```sql
-- Available in weather_gold database
SELECT * FROM vw_weather_readings
SELECT * FROM vw_city_hourly_summary
SELECT * FROM vw_temperature_predictions
SELECT * FROM vw_air_quality
```

Endpoint: `uk-weather-synapse-ondemand.sql.azuresynapse.net`

---

## Key Learnings

- Terraform from day one avoids all import complexity
- ADF + Databricks decoupled pipeline pattern
  (ingestion and transformation on different cadences)
- Unity Catalog governs data, ADLS Gen2 owns data
- OAuth2 Service Principal preferred over PAT tokens
  for service-to-service authentication
- MLlib for big data, sklearn for datasets under 10M rows
- External Delta tables visible in both Databricks
  and Synapse simultaneously

---

## Author

**Samuel Igwilo** — Senior Data Engineer  
MSc Data Science & AI, Bournemouth University (2024)  
[GitHub](https://github.com/Decupe)


