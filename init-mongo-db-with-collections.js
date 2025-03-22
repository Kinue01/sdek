db.createUser({
    user: "sdek",
    pwd: "sdek12345",
    roles: [{
        role: "readWrite",
        db: "sdek"
    }]
});

use sdek;

db.createCollection("transport_geo");
db.createCollection("warehouseLocations");
