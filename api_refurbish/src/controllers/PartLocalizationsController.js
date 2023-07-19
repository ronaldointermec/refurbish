const PartLocalization = require('../models/PartLocalization');
const Part = require('../models/Part');
const Localization = require('../models/Localization');
const RequisitionStorage = require('../models/RequisitionStorage');
const { Op } = require('sequelize');
const connection = require('../database');
const { addLog } = require('../logServices');

module.exports = {
    async index(req, res) {
        const { pn } = req.params;
        // verifica se tem letra
        /*  var regExp = /[a-zA-Z]/g;
        var hasLetter =  regExp.test(pn); */

        addLog(
            'Dentro do INDEX',
            'INFO',
            '/partlocalizations',
            req.params,
            null,
            req.method,
            req.headers,
            'PartLocalizations'
        );

        if (!pn) {
            addLog(
                'VALIDAÇÃO: PN não foi informado!',
                'ERR',
                '/partlocalizations',
                req.params,
                null,
                req.method,
                req.headers,
                'PartLocalizations'
            );
            return res.status(400).json({ VALIDAÇÃO: 'PN não foi informado!' });
        }

        try {
            let sqlLog;
            const partlocalizations = /* hasLetter ===false ? */ await PartLocalization.findAll({
                //raw: true,
                attributes: ['id'],
                logging: (sql) => {
                    sqlLog = sql;
                },
                include: [
                    {
                        association: 'parts',
                        attributes: ['id', 'pn', 'description'],
                        where: {
                            [Op.or]: [
                                { pn: { [Op.like]: `%${pn}%` } },
                                { description: { [Op.like]: `%${pn}%` } },
                            ],
                        },
                    },
                    {
                        association: 'status',
                        attributes: [],
                        where: {
                            id: 1,
                        },
                    },
                    {
                        association: 'localizations',
                        attributes: ['id', 'address'],
                    },
                ],
            });

            /* if (partlocalizations.length === 0) {
                //return res.status(400).json({ VALIDAÇÃO: 'PN não foi localizado' })
                return res.status(200).json(partlocalizations)
            } */

            addLog(
                `Encontrou ${partlocalizations.length} registros!`,
                'INFO',
                '/partlocalizations',
                req.params,
                sqlLog,
                req.method,
                req.headers,
                'PartLocalizations'
            );

            return res.status(200).json(partlocalizations);
        } catch (error) {
            addLog(
                `Erro ao localizar PartLoclization!: ${error}`,
                'ERR',
                '/partlocalizations',
                req.params,
                null,
                req.method,
                req.headers,
                'PartLocalizations'
            );
            return res.status(400).json({ ERRO: `Erro ao localizar PartLoclization!: ${error}` });
        }
    },

    async store(req, res) {
        addLog(
            `Dentro do STORE`,
            'INFO',
            '/partlocalizations',
            req.body,
            null,
            req.method,
            req.headers,
            'PartLocalizations'
        );
        const t = await connection.transaction();
        try {
            let sqlLog;
            const { pn, address, created_by, quantity } = req.body;

            if (typeof quantity === 'undefined' || quantity < 1) {
                addLog(
                    `QUANTIDADE: 'Quantidade não informada!`,
                    'ERR',
                    '/partlocalizations',
                    req.body,
                    null,
                    req.method,
                    req.headers,
                    'PartLocalizations'
                );
                return res.status(400).json({ QUANTIDADE: 'Quantidade não informada!' });
            }
            const status_id = 1;

            const part = await Part.findOne({ where: { pn }, transaction: t, logging: (sql) => (sqlLog = sql) });
            if (part === null) {
                addLog(
                    `PARTNUMBER: 'O PN não está cadastrado!`,
                    'ERR',
                    '/partlocalizations',
                    req.body,
                    sqlLog,
                    req.method,
                    req.headers,
                    'PartLocalizations'
                );
                return res.status(400).json({ PARTNUMBER: 'O PN não está cadastrado!' });
            }
            const part_id = part['id'];

            const localization = await Localization.findOne({ where: { address }, transaction: t, logging: (sql) => (sqlLog = sql) });
            if (localization === null) {
                addLog(
                    `LOCALIZAÇÃO: 'O LOCAL não está cadastrado!`,
                    'ERR',
                    '/partlocalizations',
                    req.body,
                    sqlLog,
                    req.method,
                    req.headers,
                    'PartLocalizations'
                );
                return res.status(400).json({ LOCALIZAÇÃO: 'O LOCAL não está cadastrado!' });
            }
            const localization_id = localization['id'];

            for (let index = 1; index <= quantity; index++) {
                await PartLocalization.create(
                    { part_id, localization_id, status_id, created_by },
                    { transaction: t, logging: (sql) => (sqlLog = sql) }
                );
            }

            addLog(
                `Sucesso ao salvar!`,
                'INFO',
                '/partlocalizations',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'PartLocalizations'
            );

            await t.commit();
            return res.status(200).json({ SALVAR: 'Sucesso ao salvar!' });
        } catch (err) {
            await t.rollback();
            addLog(
                `Falha ao salvar. ERRO: ${err}`,
                'ERR',
                '/partlocalizations',
                req.body,
                null,
                req.method,
                req.headers,
                'PartLocalizations'
            );
            console.log(err);
            return res.status(400).json({ SALVAR: 'Falha ao salvar' });
        }
    },

    async update(req, res) {
        addLog(
            'Dentro do UPDATE',
            'INFO',
            '/partlocalizations',
            req.body,
            null,
            req.method,
            req.headers,
            'PartLocalizations'
        );
        const { id, updated_by } = req.body;
        const t = await connection.transaction();

        try {
            let sqlLog
            const status_id = 1;
            await RequisitionStorage.destroy({
                where: { partlocalization_id: id },
                transaction: t,
                logging: (value) => {
                    sqlLog = value;
                }
            });

            addLog(
                'Destruído de RequisitionStorage',
                'INFO',
                '/partlocalizations',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'PartLocalizations'
            );

            await PartLocalization.update(
                { status_id, updated_by },
                {
                    where: { id },
                    transaction: t,
                }
            );

            
            await t.commit();
            
            addLog(
                'Sucesso na atualização',
                'INFO',
                '/partlocalizations',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'PartLocalizations'
            );
            
            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar!' });
        } catch (err) {
            await t.rollback();
            addLog(
                'Sucesso na atualização',
                'ERR',
                '/partlocalizations',
                req.body,
                null,
                req.method,
                req.headers,
                'PartLocalizations'
            );
            return res.stutus(400).json({ ERRO: `Erro ao atualizar estoque!: ${err}` });
        }
    },
};
