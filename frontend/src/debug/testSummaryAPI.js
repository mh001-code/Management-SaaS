// Test file to verify API response structure
// Run this in the browser console to debug

async function testSummaryAPI() {
  try {
    const token = localStorage.getItem("token");
    const response = await fetch("http://localhost:5000/summary", {
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });
    
    const data = await response.json();
    
    console.group("🔍 Summary API Response");
    console.log("Full Response:", data);
    console.log("ordersByStatus:", data.ordersByStatus);
    console.log("ordersByStatus type:", typeof data.ordersByStatus);
    console.log("ordersByStatus is array?", Array.isArray(data.ordersByStatus));
    console.log("ordersByStatus length:", data.ordersByStatus?.length);
    console.log("ordersByStatus has data?", data.ordersByStatus?.length > 0);
    
    if (Array.isArray(data.ordersByStatus)) {
      console.log("Sample items:");
      data.ordersByStatus.forEach((item, idx) => {
        console.log(`  [${idx}]`, item);
      });
    }
    console.groupEnd();
    
    return data;
  } catch (err) {
    console.error("❌ Error fetching summary:", err);
  }
}

// Call it
testSummaryAPI();
