const { addLog } = require('../logServices');
const MicrosigaStatusMessage = require('../models/MicrosigaStatusMessage');
const connection = require('../database');

module.exports = {
    async index(req, res) {
        try {
            let sqlLog;
            const microsigaStatusMessage = await MicrosigaStatusMessage.findAll({
                attributes: ['id', 'message'],
                logging: (value) => {
                    sqlLog = value;
                },
            });
            addLog(
                'Dentro do INDEX. Resposta: ' + JSON.stringify(microsigaStatusMessage),
                'INFO',
                '/microsigaStatusMessages',
                null,
                sqlLog,
                req.method,
                req.headers,
                'MicrosigaStatusMessage'
            );
            return res.json(microsigaStatusMessage);
        } catch (err) {
            addLog(
                'ERRO NO INDEX. Erro: ' + err,
                'ERR',
                '/microsigaStatusMessages',
                null,
                null,
                req.method,
                req.headers,
                'MicrosigaStatusMessage'
            );
            return res.status(400).json({ ERRO: `Erro ao listar status de mensagens: ${err}` });
        }
    },

    async store(req, res) {
        const { message, created_by } = req.body;
        let sqlLog;
        const t = await connection.transaction();
        try {
            const microsigaStatusMessage = await MicrosigaStatusMessage.create({
                message,
                created_by,
                transaction: t,
                logging: (value) => {
                    sqlLog = value;
                },
            });
            addLog(
                `Dentro do STORE. MicrosigaStatusMessage ${JSON.stringify(
                    message
                )} criado com sucesso!`,
                'INFO',
                '/microsigaStatusMessages',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'MicrosigaStatusMessage'
            );
            t.commit();
            return res.json(microsigaStatusMessage);
        } catch (err) {
            t.rollback();
            addLog(
                'ERRO NO STORE DA MENSAGEM. Erro: ' + err,
                'ERR',
                '/microsigaStatusMessages',
                req.body,
                null,
                req.method,
                req.headers,
                'MicrosigaStatusMessage'
            );
            return res.status(400).json({ ERRO: `Erro ao criar status de mensagem: ${err}` });
        }
    },
};
