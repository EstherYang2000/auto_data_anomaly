# auto_data_anomaly

This README outlines the steps to set up and execute the data anomaly detection workflow using dbt and Elementary. Follow the instructions below to ensure smooth execution.

---

## **Setup Instructions**

### **1. Activate Virtual Environment**
Activate the Python virtual environment where `dbt` and `Elementary` are installed:
```bash
source venv/bin/activate

```
### **2. Navigate to the dbt Project Directory**
Change your working directory to the dbt/dcard folder where the dbt project is located:

```bash
cd dbt/dcard

```
## **Execution Workflow**
### **3. Run dbt Tests**
Run the dbt tests to validate your models and ensure data quality:


```bash
dbt test
```

### **4. Execute dbt Models**
Run the dbt models to perform data transformations:

```bash
dbt run
```

### **5. Start Elementary Monitoring**
Start the Elementary monitoring tool to observe data anomaly detection in real time:


```bash
edr monitor
edr monitor --slack-token [SLACK_API_TOKEN] --slack-channel-name [CHANNEL] --profiles-dir [PROJECT_DIR]
```

### **6. Generate Elementary Reports**
Generate a detailed report of the anomalies detected:

```bash
edr report
```

