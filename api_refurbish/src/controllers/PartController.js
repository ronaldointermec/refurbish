const { Op } = require('sequelize');
const { addLog } = require('../logServices');
const Part = require('../models/Part');

module.exports = {
    async index(req, res) {
        const { pn } = req.params;
        addLog(
            'Dentro do INDEX',
            'INFO',
            '/parts',
            req.params,
            null,
            req.method,
            req.headers,
            'Part'
        );
        try {
            let sqlLog;
            const part = pn
                ? await Part.findOne({
                      attributes: ['id', 'pn', 'description'],
                      logging: (value) => {
                          sqlLog = value;
                      },
                      where: {
                          pn,
                      },
                  })
                : await Part.findAll({
                      attributes: ['id', 'pn', 'description'],
                      logging: (value) => {
                          sqlLog = value;
                      },
                  });

            /*  if (part.length === 0) {
               return res.status(400).json({ VALIDAÇÃO: 'PN não foi localizado' })
            } 
           */
            addLog(
                `Encontrou ${part ? part.length : 0} itens`,
                'INFO',
                '/parts',
                req.params,
                sqlLog,
                req.method,
                req.headers,
                'Part'
            );
            return res.status(200).json(part);
        } catch (err) {
            addLog(
                `Erro ao localizar PN! ${err}`,
                'ERR',
                '/parts',
                req.params,
                null,
                req.method,
                req.headers,
                'Part'
            );
            return res.status(400).json({ ERRO: `Erro ao localizar PN! ${err}` });
        }
    },

    async store(req, res) {
        addLog(
            `Dentro do STORE`,
            'INFO',
            '/parts',
            req.body,
            null,
            req.method,
            req.headers,
            'Part'
        );
        const { pn, description, created_by } = req.body;
        try {
            let sqlLog;
            const part = await Part.create(
                { pn, description, created_by },
                {
                    logging: (value) => {
                        sqlLog = value;
                    },
                }
            );
            addLog(
                `Criou o pn ${pn} com sucesso!`,
                'INFO',
                '/parts',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'Part'
            );
            return res.status(200).json(part);
        } catch (err) {
            addLog(
                `Erro ao salvar PN!: ${err}`,
                'ERR',
                '/parts',
                req.body,
                null,
                req.method,
                req.headers,
                'Part'
            );
            return res.status(400).json({ ERRO: `Erro ao salvar PN!: ${err}` });
        }
    },
};
