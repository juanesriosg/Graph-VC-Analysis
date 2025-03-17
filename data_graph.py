import networkx as nx
import pandas as pd
import dash
from dash import dcc, html, Input, Output
import dash_cytoscape as cyto

def create_investor_graph(data):
    print(data)
    # Create a graph
    G = nx.Graph()

    # Dictionary to track existing nodes
    existing_nodes = set()

    # Iterate over the dataset to build relationships
    for _, row in data.iterrows():
        company = row["Company Name"]
        partner = row["Lead Partner"]

        # Add the partner node if it doesn't exist
        if partner not in existing_nodes:
            G.add_node(partner)
            existing_nodes.add(partner)

        # Create edges between all partners of the same company
        company_partners = data[data["Company Name"] == company]["Lead Partner"].unique()
        
        for other_partner in company_partners:
            if other_partner != partner:  # Avoid self-loops
                G.add_edge(partner, other_partner)

    return G

def create_investor_graph_from_investor(data,name):
    data = data[data['Lead Partner'] == name]
    companies = data['Company Name'].unique()

    data_filtered = data[data['Company Name'].isin(companies)]
    G = create_investor_graph(data_filtered)
    return G

# Convert NetworkX graph to Cytoscape elements
def generate_cytoscape_elements(G):
    nodes = [{"data": {"id": node, "label": node}} for node in G.nodes()]
    edges = [{"data": {"source": u, "target": v}} for u, v in G.edges()]
    print(len(nodes))
    return nodes + edges

#read the data
cleaned_data = pd.read_csv('cleaned_data.csv')
df = cleaned_data[['Company Name', 'Lead Partner', 'Primary Industry Sector']].head(10)

# Create the graph
G = create_investor_graph(df)

# Initial graph elements
elements = generate_cytoscape_elements(G)

# Dash app setup
app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1("Interactive Investor Network Graph", style={'textAlign': 'center'}),
    
    # Search bar
    dcc.Input(id="search-input", type="text", placeholder="Enter investor name...", debounce=True),

    # Cytoscape graph
    cyto.Cytoscape(
        id="cytoscape-graph",
        elements=elements,
        style={"width": "100%", "height": "600px"},
        layout={"name": "cose"},  # Force-directed layout
        stylesheet=[
            {"selector": "node", "style": {"label": "data(label)", "width": "20px", "height": "20px", "background-color": "#3498db"}},
            {"selector": ".highlight", "style": {"width": "50px", "height": "50px", "background-color": "#e74c3c", "font-size": "20px"}}
        ]
    )
])

# Callback to update the graph when searching for an investor
# @app.callback(
#     Output("cytoscape-graph", "elements"),
    
# )
# def update_graph(search_value):
    
#     if not search_value or search_value not in df['Lead Partner'].values:
#         return generate_cytoscape_elements(G)  # Show full graph if no search

#     # Create a new graph centered on the searched investor
#     new_G = create_investor_graph_from_investor(df, search_value)
#     return generate_cytoscape_elements(new_G)

# Run the Dash app
if __name__ == "__main__":
    app.run_server(debug=True)