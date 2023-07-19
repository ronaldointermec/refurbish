const PartLocalization = require('../models/PartLocalization');
const Part = require('../models/Part');
const Localization = require('../models/Localization');
const { Op, Sequelize } = require('sequelize');
const { index } = require('./PartController');
const { count } = require('../models/PartLocalization');
const logService = require('../logServices')


module.exports = {

    async index(req, res) {

        const { inicialDate, endDate } = req.body;
        logService.addLog('index', 'INFO', '/report/posicaoEstoque', req.body, null, 'POST', req.headers, "ReportPosicaoEstoque")
        try {
            let sqlLog
            const partlocalizations = await PartLocalization.findAll({
                raw: true,
                attributes: [],
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
                        association: 'parts',
                        attributes: ['pn', 'description', [Sequelize.fn('COUNT', Sequelize.col('parts.pn')), 'qtd']],
                    },
                    {
                        association: 'status',
                        attributes: ['description'],

                    },
                    {
                        association: 'localizations',
                        attributes: ['address'],
                    }
                ],
                group: ["parts.pn", "parts.description", "status.description", "localizations.address"],
                count: ["parts.pn"],
            }
            );

            /* if (partlocalizations == 0) {
                return res.status(400).json('Não foi encontrado nenhum registro com este filtro');
            } else {
                return res.status(200).json(partlocalizations);
            } */

            logService.addLog('Estoque encontrado', 'INFO', '/report/posicaoEstoque', req.body, sqlLog, 'POST', req.headers, "ReportPosicaoEstoque")
            return res.status(200).json(partlocalizations);
        } catch (err) {
            logService.addLog(`Erro ao recuperar estoque: ${err}`, 'INFO', '/report/posicaoEstoque', null, null, 'POST', req.headers, "ReportPosicaoEstoque")
            return res.status(400).json(`Erro ao recuperar estoque: ${err}`);
        }
    }

};