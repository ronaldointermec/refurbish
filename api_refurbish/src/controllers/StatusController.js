const Status = require('../models/Status');
const connection = require('../database')
const logService = require('../logServices')
module.exports = {

    async index(req, res) {

        logService.addLog('index', 'INFO', '/status', req.params, null, 'GET', req.headers, "Status")

        try {
            let sqlLog
            const status = await Status.findAll({
                logging: (value) => {
                    sqlLog = value
                },
                attributes: ["id", "description"]
            });

            logService.addLog('Status encontrados', 'INFO', '/status', req.params, sqlLog, 'GET', req.headers, "Status")
            return res.status(200).json(status);
        } catch (err) {
            logService.addLog(`Erro ao recuperar status: ${Error}`, 'INFO', '/status', null, null, 'GET', req.headers, "Status")
            return res.status(400).json({ ERROR: `Erro ao recuperar status: ${Error}` })

        }

    },

    async store(req, res) {
        const { description, created_by } = req.body;
        logService.addLog('store', 'INFO', '/status', req.body, null, 'POST', req.headers, "Status")

        const t = await connection.transaction();
        try {

            let sqlLog
            const status = await Status.create(
                {
                    description,
                    created_by
                },
                {
                    logging: (value) => {
                        sqlLog = value
                    },
                    transaction: t
                },

            );
            await t.commit();
            logService.addLog('Sucesso ao salvar Status', 'INFO', '/Status', req.body, sqlLog, 'POST', req.headers, "Status")
            return res.status(200).json("Sucesso ao salvar Status!");
        } catch (err) {
            await t.rollback();
            logService.addLog(`Erro ao salvar Status: ${err}`, 'INFO', '/Status', null, null, 'POST', req.headers, "Status")
            return res.status(400).json({ ERROR: `Erro ao salvar Status: ${err}` })
        }

    }
};