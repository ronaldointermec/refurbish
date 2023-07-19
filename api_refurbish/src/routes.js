const express = require('express');

const PecaController = require('./controllers/PartController');
const LocalizationController = require('./controllers/LocalizationController');
const ReasonController = require('./controllers/ReasonsController');
const StatusController = require('./controllers/StatusController');
const PartLocalizationsController = require('./controllers/PartLocalizationsController');
const OrdersControlller = require('./controllers/OrdersController');
const RequisitionController = require('./controllers/RequisitionController');
const ReportPosicaoEstoqueController = require('./controllers/ReportPosicaoEstoqueController');
const ReportPecaSolicitadaEntregueController = require('./controllers/ReportPecaSolicitadaEntregueController');
const ShipmentController = require('./controllers/ShipmentController');
const MicrosigaLoanController = require('./controllers/MicrosigaLoanController')
const MicrosigaStatusMessageController = require('./controllers/MicrosigaStatusMessageController');
const NcrController = require('./controllers/NcrController');

const routes = express.Router();

routes.post('/parts', PecaController.store);
routes.get('/parts/:pn', PecaController.index);
routes.get('/parts', PecaController.index);

routes.post('/localizations', LocalizationController.store);
routes.get('/localizations', LocalizationController.index);
routes.get('/localizations/:address', LocalizationController.index);

routes.post('/reasons', ReasonController.store);
routes.get('/reasons', ReasonController.index);

routes.post('/status', StatusController.store);
routes.get('/status', StatusController.index);

routes.post('/partlocalizations', PartLocalizationsController.store);
routes.get('/partlocalizations', PartLocalizationsController.index);
routes.get('/partlocalizations/:pn', PartLocalizationsController.index);
routes.patch('/partlocalizations', PartLocalizationsController.update);

routes.post('/orders', OrdersControlller.store);
routes.get('/orders/:os', OrdersControlller.index);

routes.post('/requisitions', RequisitionController.index);
routes.patch('/requisitions', RequisitionController.update);

routes.patch('/emprestimo', RequisitionController.updateEmprestimo);

routes.patch('/loans', RequisitionController.criar);


routes.post('/reimpressao', RequisitionController.indexReimpressao);

routes.post('/report/posicaoEstoque', ReportPosicaoEstoqueController.index);
routes.post('/report/pecaSolicitadaEntregue', ReportPecaSolicitadaEntregueController.index);

routes.post('/shipment', ShipmentController.store);
routes.post('/shipmentConsultaOS', ShipmentController.indexOS);
routes.get('/shipment', ShipmentController.index);
routes.get('/shipment/:os', ShipmentController.index);
routes.patch('/shipment', ShipmentController.update);

//routes.post('/shipmentConsultaOS', ShipmentController.index);

routes.post('/loan', MicrosigaLoanController.store);
routes.get('/loan/:os', MicrosigaLoanController.index);
routes.get('/loan', MicrosigaLoanController.index);
routes.patch('/loan', MicrosigaLoanController.update);

routes.post('/microsigaSatatusMessages', MicrosigaStatusMessageController.store);
routes.get('/microsigaSatatusMessages', MicrosigaStatusMessageController.index);

routes.post('/ncr',NcrController.store);
routes.get('/ncr',NcrController.index);
routes.get('/ncr/:os',NcrController.index);
routes.patch('/ncr', NcrController.update);


module.exports = routes;