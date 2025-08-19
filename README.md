# 🌐 Cluster Based False Aggregate Detection System (CBFADS) in Wireless Sensor Networks

This repository contains the implementation of **Cluster Based False Aggregate Detection System (CBFADS)** using the **NS2 simulator**.  
The project follows a hierarchical Wireless Sensor Network (WSN) model with **dynamic cluster head selection**, **data aggregation**, and **intrusion detection** at the base station.

---

## 📖 Overview
- **Simulator**: NS2  
- **Key Features**:
  - Dynamic Cluster Head Selection (energy-based)
  - Data Aggregation at Cluster Heads
  - Intrusion Detection System (IDS) at Base Station
- **Performance Metrics**:
  - Throughput  
  - Delay  
  - Accuracy  
  - Energy Efficiency  

---

## 📂 Repository Structure
```
CBFADS-WSN/
│
├── src/                  # Source TCL code
│   ├── main.tcl          # Main NS2 simulation script
│   └── algorithms/       # Pseudocode for algorithms
│
├── results/              # Simulation results & graphs
│   ├── throughput.png
│   ├── delay.png
│   ├── accuracy.png
│   └── packet_loss.png
│
├── docs/                 # Project documentation
│   ├── Project_Report.pdf
│   ├── Pseudocode_Report.docx
│   └── Simulation_Output.docx
│
├── data/                 # Sample outputs / logs
│   └── sample_run_output.txt
│
├── README.md             # Project documentation (this file)
└── LICENSE               # License (if added)
```

---

## 🛠️ How to Run
1. Install **NS2 (v2.35 recommended)**  
   👉 [NS2 Installation Guide](https://www.isi.edu/nsnam/ns/)  

2. Clone this repository:
   ```bash
   git clone https://github.com/sriramavivek/Cluster-Based-False-Aggregate-Detection-System-in-Wireless-Sensor-Networks-.git
   cd Cluster-Based-False-Aggregate-Detection-System-in-Wireless-Sensor-Networks-/src
   ```

3. Run the simulation:
   ```bash
   ns main.tcl
   ```

4. View results in **NAM**:
   ```bash
   nam sensor_network.nam
   ```

---

## 📊 Performance Comparison
| Protocol | Throughput (bps) | Accuracy (%) | Delay (ms) | Packet Loss (%) |
|----------|------------------|--------------|------------|-----------------|
| LEACH    | 800              | 85           | 300        | 15              |
| HEED     | 950              | 88           | 350        | 12              |
| PEGASIS  | 875              | 87           | 280        | 10              |
| TEEN     | 700              | 84           | 250        | 8               |
| **CBFADS (Proposed)** | **1100** | **92** | **200** | **5** |

---

## 📜 References
- IEEE Paper: *Cluster Based False Aggregate Detection System in Wireless Sensor Networks*  
- Simulation results derived from NS2 implementation  

---

## 👨‍💻 Contributors
- **SriRama Vivek** (Lead Developer)
- Adeebulla Khan  
- Chaitanya Kumar  
- Gnana Dileep Reddy  
- Siva Sathvik  

---

## 📌 License
This project is for **academic/research purposes**. You may use and modify it with proper citation.

