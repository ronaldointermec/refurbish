const Sequelize = require('sequelize');
const dbConfig = require('../config/database');


const Part = require('../models/Part');
const Localization = require('../models/Localization');
const Reason = require('../models/Reason');
const Status = require('../models/Status');
const PartLocalization = require('../models/PartLocalization');
const Order= require('../models/Order');
const Requisition = require('../models/Requisition');
const RequisitionStorage = require('../models/RequisitionStorage');
const Shipment = require('../models/Shipment');
const MicrosigaLoan = require('../models/MicrosigaLoan');
const MicrosigaStatusMessage = require('../models/MicrosigaStatusMessage')
const MicrosigaNcr = require('../models/MicrosigaNcr');

const connection = new Sequelize(dbConfig);

Part.init(connection);
Localization.init(connection);
Reason.init(connection);
Status.init(connection);
PartLocalization.init(connection);
Order.init(connection);
Requisition.init(connection);
RequisitionStorage.init(connection);
Shipment.init(connection);
MicrosigaLoan.init(connection);
MicrosigaStatusMessage.init(connection);
MicrosigaNcr.init(connection);


Part.associate(connection.models);
Localization.associate(connection.models);
PartLocalization.associate(connection.models);
Requisition.associate(connection.models);
Order.associate(connection.models);
RequisitionStorage.associate(connection.models);
Shipment.associate(connection.models);
MicrosigaLoan.associate(connection.models)
MicrosigaNcr.associate(connection.models);


module.exports = connection;