db = db.getSiblingDB('sdek');

db.createUser({
    user: "sdek",
    pwd: "sdek12345",
    roles: [{
        role: "readWrite",
        db: "sdek"
    }]
});

db.createCollection("transport_geo");
db.createCollection("warehouseLocations");
