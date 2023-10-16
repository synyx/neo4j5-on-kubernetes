MATCH (o1:Order {id:'1'}),(o2:Order {id:'2'}),(o3:Order {id:'3'}),(o4:Order {id:'4'}),(o5:Order {id:'5'}), (o6:Order {id:'6'}), (o7:Order {id:'7'}), (o8:Order {id:'8'})
MERGE (c1:Customer {name:'Eiffeltum',longitude: 2.2668765, latitude: 48.8529209, location: 'Paris'})-[:HAS_ORDERED]->(o1)
MERGE (c1)-[:HAS_ORDERED]->(o2)
MERGE (c2:Customer {name:'synyx',longitude: 8.3844571, latitude: 49.0038173, location: 'Karlsruhe'})-[:HAS_ORDERED]->(o3)
MERGE (c2)-[:HAS_ORDERED]->(o4)
MERGE (c3:Customer {name:'Brandenburger Tor',longitude: 13.0951145, latitude: 52.5068042, location: 'Berlin'})-[:HAS_ORDERED]->(o5)
MERGE (c3)-[:HAS_ORDERED]->(o6)
MERGE (c3)-[:HAS_ORDERED]->(o7)
MERGE (c3)-[:HAS_ORDERED]->(o8)