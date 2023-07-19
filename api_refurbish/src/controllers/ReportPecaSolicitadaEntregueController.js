
const { Sequelize, Op, where } = require('sequelize');
const Requisition = require('../models/Requisition');
const PartLocalization = require('../models/PartLocalization');
const connection = require('../database');
const logService = require('../logServices')

module.exports = {
    async index(req, res) {

        const { inicialDate, endDate } = req.body;
        logService.addLog('index', 'INFO', '/report/pecaSolicitadaEntregue', req.body, null, 'POST', req.headers, "ReportPecaSolicitadaEntregue")

        try {
            let sqlLog
            const requisition = await Requisition.findAll({
                raw: true,
                attributes: ["id", "created_by", "updated_by", "created_at", "updated_at"],
                logging: (value) => {
                    sqlLog = value
                },
                where: {
                    created_at: {
                        [Op.between]: [inicialDate, endDate],
                    }
                },
                include: [
                    {
                        association: 'order',
                        required: true,
                        attributes: ["os", "contract_type", "days"],
                    },
                    {
                        association: 'status',
                        required: true,
                        attributes: ['description'],
                    },
                    {
                        association: 'requisitionStorages',
                        required: true,
                        attributes: [],

                        include: [{
                            association: 'reasons',
                            required: true,
                            attributes: ['description'],

                        },
                        {
                            association: 'partlocalizations',
                            required: true,
                            attributes: [],

                            include: [
                                {
                                    association: 'localizations',
                                    required: true,
                                    attributes: ['address'],
                                },
                                {
                                    association: 'parts',
                                    required: true,
                                    attributes: ['pn', 'description'],
                                },
                            ],

                        }]
                    }
                ],

            })

            /*   if (requisition.length === 0) {
                  return res.status(400).json({ VALIDAÇÃO: "Requisição não foi localizada" });
              } */
            logService.addLog('Peças encontradas', 'INFO', '/report/pecaSolicitadaEntregue', req.body, sqlLog, 'POST', req.headers, "ReportPecaSolicitadaEntregue")

            return res.status(200).json(requisition);

        } catch (err) {
            logService.addLog(`Erro ao localizar requisição!:  ${err}`, 'INFO', '/report/pecaSolicitadaEntregue', null, null, 'POST', req.headers, "ReportPecaSolicitadaEntregue")
            return res.status(400).json({ ERRO: `Erro ao localizar requisição!:  ${err}` })
        }
    }


};