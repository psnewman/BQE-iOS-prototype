# Figma MCP Server: Quick Reference Guide

## 1. Extracting Information from Figma URLs

```
https://www.figma.com/design/uRrs8r0ioJuuBSlcNyGYaB/Dashboards?node-id=610-15029
                            └───    File Key    ───┘                └─ Node ID ─┘
```

- **File Key**: Unique identifier for your Figma file
- **Node ID**: Specific frame/component ID (convert hyphen to colon for API: `610-15029` → `610:15029`)

## 2. Basic MCP Request Structure

```javascript
{
  "fileKey": "uRrs8r0ioJuuBSlcNyGYaB", // From URL
  "nodeId": "610:15029",               // Convert hyphen to colon
  "depth": 3                             // Adjust based on nesting
}
```

## 3. Depth Parameter Guide

- **depth=1**: Frame only, no children (best for initial component set exploration)
- **depth=2-3**: Good balance for most components
- **depth=5+**: Only for deeply nested elements

## 4. Response Structure Overview

```javascript
{
  "metadata": { /* File information */ },
  "nodes": [{
    "id": "610:15029",
    "name": "Dashboard Card",
    "type": "COMPONENT",
    "fills": "fill_KMJ2AH",      // Reference to styles
    "borderRadius": "8px",       // Direct properties
    "children": [ /* Nested elements */ ]
  }],
  "globalVars": { /* Global styles and variables */ }
}
```

## 5. Key Properties to Extract

- **Visual Properties**: `fills` (backgrounds), `strokes` (borders), `effects` (shadows)
- **Layout**: `layout` (mode, padding, gap), `borderRadius`, dimensions
- **Typography**: `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`

## 6. MCP Inspector Quick Start

1. Run: `pnpm mcp-inspector`
2. Select `get_figma_data` tool
3. Enter parameters (fileKey, nodeId, depth)
4. Click "Execute"
5. Use the JSON viewer to explore the response

## 7. Finding Nested Frames

When a Figma URL points to a parent frame but you need a specific child frame:

1. Fetch parent frame data first using the node ID from URL
2. Search through response for the frame by name
3. Use the found ID for further operations

Example:
```javascript
// For URL with node-id=20643-173967, looking for "empty-states" frame
// Step 1: Fetch parent frame
{
  "fileKey": "eAH71zmf2oKxIhMrw6SXTK",
  "nodeId": "20643:173967",
  "depth": 1
}
// Step 2: Search response for "empty-states"
// Step 3: Use found ID (e.g., "20643:174641") for specific operations
```

## 8. Component Set Optimization

For component sets with multiple variants:

1. **First Request**: Fetch parent component set with shallow depth
   ```javascript
   {
     "fileKey": "y7QujUyzIYZTb9F4IKYuUc",
     "nodeId": "5137:13948",
     "depth": 1
   }
   ```

2. **Second Request**: Fetch only the specific variant
   ```javascript
   {
     "fileKey": "y7QujUyzIYZTb9F4IKYuUc",
     "nodeId": "5137:13961",  // ID of specific variant
     "depth": 3
   }
   ```

## 9. Handling Response Truncation

If responses are truncated:
- Reduce the depth parameter
- Target specific nodes instead of parent containers
- Make multiple targeted requests

## 10. Best Practices

- Search by naming patterns (e.g., `State=X, Placeholder=Y`)
- Document component hierarchy and naming conventions
- Start with lower depth values and increase as needed
- Use consistent node ID format (colons, not hyphens)

## 11. Important: Fetching Specific Child Frames vs. Parent Frames

When sharing a Figma link, it's crucial to understand the hierarchy of frames to ensure you fetch exactly what you want:

### Understanding Frame Hierarchy

- **Root Frame**: The top-level container (e.g., a page or screen)
- **Parent Frame**: A container that holds multiple child components
- **Child Frame**: A specific component within a parent frame

### Problem: Fetching the Wrong Frame

A common issue occurs when you share a link to a specific child frame, but the MCP server returns the parent frame instead. For example:

```
https://www.figma.com/design/uRrs8r0ioJuuBSlcNyGYaB/Dashboards?node-id=784-19018
```

This link points to a specific child component, but if you simply extract the node ID as `784:19018`, you might actually get the parent "Collection page / Grid view" frame instead of the specific component you wanted.

### Solution: Verify the Node Type and Name

To ensure you're fetching the exact frame:

1. **Check the Response Metadata**: After fetching data, immediately check the `name` and `type` properties:
   ```javascript
   {
     "id": "784:19018",
     "name": "Collection page / Grid view", // Is this the component you expected?
     "type": "FRAME"
   }
   ```

2. **Inspect Children**: If you received a parent frame, look through the `children` array to find the specific component you want:
   ```javascript
   "children": [
     {
       "id": "784:19019",
       "name": "Top Bar", // This might be the component you actually wanted
       "type": "INSTANCE"
     }
   ]
   ```

3. **Use the Correct Node ID**: Once you've identified the correct component, use its ID for subsequent requests.

### Best Practice: Use the MCP Inspector

The MCP Inspector is invaluable for navigating frame hierarchy:

1. Start with the node ID from your URL
2. Fetch the data and examine the response
3. If you received a parent frame, note the ID of the specific child component
4. Make a new request with the child component's ID

By following these steps, you can ensure you're implementing exactly the component you intended, not its parent or an entire screen.

## 9. Finding Specific Nested Frames by Name

When working with Figma links, you'll often encounter a situation where you select a specific nested frame in Figma, but the URL contains the ID of a parent frame. Here's how to handle this:

### Understanding the Issue

When you copy a link to a specific frame in Figma (like "Toolbar View Selector" or "empty-states"), the URL typically contains:
- The file key (e.g., `eAH71zmf2oKxIhMrw6SXTK`)
- A node ID that refers to the parent frame (e.g., `20643-173967`), not the specific nested frame you selected

### Solution: Search by Frame Name

To find a specific nested frame when you only have the parent frame ID:

1. **Fetch the parent frame data first**:
   ```javascript
   {
     "fileKey": "eAH71zmf2oKxIhMrw6SXTK",
     "nodeId": "20643:173967", // Convert hyphen to colon
     "depth": 5                // Include enough depth to capture nested frames
   }
   ```

2. **Search through the response for the frame by name**:
   ```javascript
   // Example response structure
   {
     "nodes": [{
       "id": "20643:173967",
       "name": "Empty state / No reports", // Parent frame
       "children": [
         {
           "id": "20643:173968",
           "name": "content",
           "children": [
             {
               "id": "20643:173971",
               "name": "content",
               "children": [
                 {
                   "id": "20643:174641",
                   "name": "empty-states", // The specific frame we want
                   "type": "INSTANCE"
                 }
               ]
             }
           ]
         }
       ]
     }]
   }
   ```

3. **Once you find the specific frame by name, use its ID for further operations**:
   ```javascript
   // Now you can fetch just this specific frame
   {
     "fileKey": "eAH71zmf2oKxIhMrw6SXTK",
     "nodeId": "20643:174641", // ID of the specific frame
     "depth": 3
   }
   ```

### Example: Finding the "empty-states" Frame

For instance, if you have a link to a parent frame:
```
https://www.figma.com/design/eAH71zmf2oKxIhMrw6SXTK/BQE-iOS-App?node-id=20643-173967
```

But you want to access the "empty-states" frame within it:

1. First, fetch the parent frame data using the node ID from the URL
2. Search through the response for a frame named "empty-states"
3. Once found, note its ID (in this case, "20643:174641")
4. Use this ID to fetch the specific frame data

This approach allows you to precisely target the frames you need, even when Figma URLs only provide parent frame IDs.

## 10. Using the MCP Inspector

The MCP Inspector is a powerful tool for interacting with the Figma API and debugging responses. Here's a detailed guide on how to use it effectively:

### Starting the Inspector

1. Run the inspector with:
   ```bash
   pnpm mcp-inspector
   ```

2. This will start a local server (typically on port 3000) and open a web interface in your browser. If it doesn't open automatically, navigate to `http://localhost:3000`.

### Navigating the Interface

The MCP Inspector interface has several key sections:

1. **Tool Selection**: On the left side, you'll see a list of available tools, including `get_figma_data` and `download_figma_images`.

2. **Parameter Configuration**: When you select a tool, the center panel will show input fields for all required and optional parameters.

3. **Response Viewer**: After executing a request, the right panel will display the structured response.

### Making Requests

To fetch data from a specific Figma frame:

1. Select the `get_figma_data` tool from the list.

2. Fill in the parameters:
   - `fileKey`: Your Figma file key (e.g., "uRrs8r0ioJuuBSlcNyGYaB")
   - `nodeId`: The specific node ID (e.g., "610:15029")
   - `depth`: The nesting depth (e.g., 5)

3. Click the "Execute" button to send the request.

### Viewing and Analyzing Responses

The response viewer provides several features to help you analyze the data:

1. **JSON Tree View**: Expand/collapse sections to focus on specific parts of the response.

2. **Search**: Use the search box to find specific properties or values.

3. **Copy Path**: Right-click on any node to copy its path, which you can use in your code to access that specific data.

4. **Copy Value**: Copy the value of any node for use in your implementation.

### Debugging Tips

1. **Compare Responses**: Run multiple requests with different parameters to compare the results.

2. **Isolate Components**: If you're working with a complex design, fetch individual components separately to understand their structure.

3. **Experiment with Depth**: Try different depth values to find the right balance between detail and response size.

4. **Check Console**: If you encounter errors, check the browser console and terminal where the inspector is running for additional information.

### Example Workflow

1. Find a component in Figma and copy its URL.
2. Extract the file key and node ID.
3. Open the MCP Inspector and select `get_figma_data`.
4. Enter the parameters and execute the request.
5. Explore the response to understand the component's structure.
6. Use this information to implement the component in your UI Playground.

This structured approach will help you fetch exactly the components you need without getting overwhelmed by data from the entire design.

## 11. Optimization Tips for Fetching Components

When working with complex component sets or deeply nested frames in Figma, you may encounter challenges such as truncated responses or difficulty finding specific variants. Here are some optimization strategies to make the process more efficient:

### Use the Correct Node ID Format

Always convert hyphens to colons when using node IDs from Figma URLs:

```
// In Figma URL
node-id=5137-13948

// For API requests
nodeId: "5137:13948"
```

### Two-Step Approach for Component Sets

When working with component sets that have many variants:

1. **First Request**: Fetch the parent component set with a shallow depth to identify all variants
   ```javascript
   {
     "fileKey": "y7QujUyzIYZTb9F4IKYuUc",
     "nodeId": "5137:13948",
     "depth": 1  // Shallow depth to avoid truncation
   }
   ```

2. **Second Request**: Once you've identified the specific variant you need (e.g., "State=Focused, Placeholder=false"), fetch only that variant with a greater depth
   ```javascript
   {
     "fileKey": "y7QujUyzIYZTb9F4IKYuUc",
     "nodeId": "5137:13961",  // ID of the specific variant
     "depth": 3  // Greater depth for detailed information
   }
   ```

### Optimize the Depth Parameter

The `depth` parameter controls how many levels of nested children are returned:

- **Depth = 1**: Returns only immediate children (good for initial component set exploration)
- **Depth = 2-3**: Good balance for most components
- **Depth = 5+**: Use only when you need deeply nested elements

Starting with a lower depth prevents response truncation and gives you a complete overview of available components.

### Search by Naming Patterns

Figma components often follow consistent naming patterns. For example:

- Component sets may use patterns like `State=X, Placeholder=Y`
- Frames may be organized with names like `Section/Subsection/Element`

Understanding these patterns makes it easier to locate specific components in the response.

### Handle Response Truncation

If you're experiencing truncated responses:

1. Reduce the depth parameter
2. Target more specific nodes instead of parent containers
3. Make multiple targeted requests instead of one large request

### Document Component Structure

Maintain documentation of your component hierarchy and naming conventions. This makes it easier to navigate the Figma structure programmatically.

By following these optimization strategies, you can make the process of fetching and working with Figma components much more efficient and reliable.
