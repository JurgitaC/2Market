# 2Market Project - part of LSE course

**Tools used**: Excel, SQL, Tableau

📂 [Technical Report](Cepure_Jurgita_.pdf)

📂 [Presentation Slides](2Market_Presentation.pdf)


### Project Overview:
A fictional global supermarket which sells products online and in-store needs help to understand their customer purchase behaviour.

In particular, 2Market wants to understand:
- The demographics of their customers 
- Which advertising channels seem to be the most effective
- Which products seem to sell the best and if that varies based on demographic

### Key Focus Areas:
1. Customer demographic analysis:
- What are the key demographic attributes (e.g., age, education, marital
status, children, income, location) of the customer base?
- Are there any noticeable patterns or preferences among different
demographic groups?
- How do customer demographics differ between online and in-store
shopping?
2. Advertising channel effectiveness:
- Which advertising channels are most effective at driving sales both
online and in-store?
- Which advertising channels are most effective at driving sales per
country?
3. Top-selling products and customer segmentation
- What are the top-selling products across different customer segments?
- Are there any products that perform better with certain demographics or
in certain geographic areas?
- How do customer preferences differ across product categories?
- Are there any under-performing products or categories that may need
rebranding or discontinuation?
- Are there any missing product groups (e.g. dairy)
4. Considering the dual nature of 2Market's operations, understanding the split
between online and in-store business performance is essential. Insights from
this analysis can drive decisions related to resource allocation, supply chain
optimization, and inventory management.
- What is the revenue split between online and in-store sales?
- Are there different product preferences between online shoppers and in-
store shoppers?
- How does customer behaviour (average spend etc) differ across these
two channels?

### Data Source
The primary data source - *Marketing_data* file, which provided the most detailed information, while the *Ad_data* file was left-joined into it using the primary key column, *id*.

### Approach 
To create dashboards focused on answering a specific business question:

**Customer Dashboard**

A Packed Bubbles chart was chosen to visualize the distribution of customer demographics, as it effectively compares group sizes and highlights prominent categories. The Country filter was applied to all views, with a static colour range bar used to indicate the size of each group. Most views on the dashboard used the *Count of Id* measure combined with a demographic dimension (e.g., *Age_Group*, *Children*). Whereas *Income Spent Brackets* view gives joint group consisting of specific income group in relation to customers spending group.

**Advertising Dashboard**

Given that the data was not extensive enough to fully assess the effectiveness of advertising channels, I opted to compare the average *Total_Sales* of customers who encountered ads versus those who did not. Initial exploration was conducted in pgAdmin, then moved to Tableau, where two new columns—*Total_Sales_with_ad* and *Total_Sales_no_ad* —were created for further analysis. The table view clearly outlines low counts of successful ad conversions, suggesting that the data may not yet be sufficient for definitive conclusions.

Different angle on advertising and possible customers’ lack of awareness of business’ channels as well as opportunity for advertising is reflected on double horizonal bars chart with measure of *Total_Sales* and average *Total_Sales* for number and percentage share of customers on labels.

**Product Dashboard**

The focus of this dashboard was on *Total_Sales*, percentage share of total sales for each product, and the average spend on each product. Simple cards were used to display key metrics for each product, while a horizontal bar chart showes the multichannel distribution of products and average customer spend. The dashboard includes more filters to allow users to explore product distribution across various dimensions, giving them the flexibility to explore the data.

### Patterns, Trends, and Insights

The dataset was heavily skewed towards Spain, which accounted for 49% of all customers, with South Africa and Canada contributing 15% and 12%, respectively. This could be due to factors such as data collection methods, business strategy, or market characteristics, and warrants further investigation.

Key **customer** patterns reveal that the majority are in the 44-58 age group, married or in a relationship, with children, and hold a degree or higher. Most prefer in-store shopping, earn approximately $50K annually, and spend on average under $300. The latter may derive from pattern where it was found that people with children tend to be more cautious with spending. These insights are consistent across countries.

Regarding **advertising effectiveness**, the data is insufficient to definitively measure the impact of specific marketing channels also duration of campaigns is unknown. That may have had an impact too. However, the analysis suggests that customers who were not targeted by ads tend to spend more on average, whether shopping online or in-store.

On the **product** front, limiting factor was the absence of unit sales and pricing data. Nonetheless, alcoholic beverages emerged as the top-selling category based on total and average sales, followed by meat. Other product categories contributed significantly less. This trend held across most demographics and countries. Notably, dairy products were excluded from the dataset, which may have skewed product distribution analysis.
