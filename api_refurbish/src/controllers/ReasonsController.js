const Reason = require('../models/Reason');
const connection = require('../database');
const logService = require('../logServices')

module.exports = {

    async index(req, res) {

        logService.addLog('index', 'INFO', '/reasons', req.params, null, 'GET', req.headers, "Reasons")

        try {
            let sqlLog
            const reason = await Reason.findAll({
                logging: (value) => {
                    sqlLog = value
                },
                attributes: ["id", "description"]
            });
            logService.addLog('Motivos encontrados', 'INFO', '/reasons', req.params, sqlLog, 'GET', req.headers, "Reasons")
            return res.status(200).json(reason);
        } catch (err) {
            logService.addLog(`Erro ao recuperar Motivos: ${err}`, 'INFO', '/reasons', null, null, 'GET', req.headers, "Reasons")
            return res.status(400).json({ ERROR: `Erro ao recuperar motivos` })
        }

    },

    async store(req, res) {
        const { description, created_by } = req.body;
        logService.addLog('store', 'INFO', '/reasons', req.body, null, 'POST', req.headers, "Reasons")

        const t = await connection.transaction();
        try {
            let sqlLog
            const reason = await Reason.create(
                {
                    description,
                    created_by,
                },

                {
                    logging: (value) => {
                        sqlLog = value
                    },
                    transaction: t
                },

            );
            await t.commit();
            logService.addLog('Sucesso ao salvar Motivo', 'INFO', '/reasons', req.body, sqlLog, 'POST', req.headers, "Reasons")
            return res.status(200).json("Sucesso ao salvar Motivo!");
        } catch (err) {
            await t.rollback();
            logService.addLog(`Erro ao salvar Motivo: ${err}`, 'INFO', '/reasons', null, null, 'POST', req.headers, "Reasons")
            return res.status(400).json({ ERROR: `Erro ao salvar Motivo: ${err}` })
        }
    }
};