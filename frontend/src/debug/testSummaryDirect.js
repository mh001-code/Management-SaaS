import api from "../services/api.js";

// Test file - run this in browser console
async function testSummaryDirect() {
  console.log("\n🧪 Testing Summary API Response\n");
  
  try {
    // Get raw response
    const response = await fetch("http://localhost:5000/api/summary", {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${localStorage.getItem("token")}`,
        "Content-Type": "application/json"
      }
    });
    
    console.log("Status:", response.status);
    console.log("Headers:", {
      "content-type": response.headers.get("content-type"),
      "cache-control": response.headers.get("cache-control")
    });
    
    // Clone response to read body
    const text = await response.clone().text();
    console.log("Raw Response Text:", text);
    
    // Parse as JSON
    const data = await response.json();
    console.log("Parsed JSON:", data);
    
    // Analyze each field
    console.log("\n📊 Field Analysis:");
    console.log("totalOrders:", data.totalOrders, typeof data.totalOrders);
    console.log("totalClients:", data.totalClients, typeof data.totalClients);
    console.log("totalSales:", data.totalSales, typeof data.totalSales);
    console.log("topProducts:", data.topProducts, Array.isArray(data.topProducts) ? "array" : typeof data.topProducts);
    console.log("ordersByStatus:", data.ordersByStatus, Array.isArray(data.ordersByStatus) ? "array" : typeof data.ordersByStatus);
    console.log("ordersPerClient:", data.ordersPerClient, Array.isArray(data.ordersPerClient) ? "array" : typeof data.ordersPerClient);
    
  } catch (err) {
    console.error("❌ Test Error:", err);
  }
}

// Run it
testSummaryDirect();
