const { Sequelize, Op, where } = require('sequelize');
const Requisition = require('../models/Requisition');
const PartLocalization = require('../models/PartLocalization');
const RequisitionStorage = require('../models/RequisitionStorage');
const connection = require('../database');
const logService = require('../logServices')


module.exports = {

    async update(req, res) {

        const { id, updated_by, partlocalizations } = req.body;
        const status_id = 3;
        logService.addLog('update', 'INFO', '/requisitions', req.body, null, 'PATCH', req.headers, "Requisition")

        const t = await connection.transaction();

        try {
            let sqlLog
            const requisition = await Requisition.update(
                {
                    status_id,
                    updated_by
                },
                {
                    logging: (value) => {
                        sqlLog = value
                    },
                    where: {
                        id
                    },
                    transaction: t
                });

            const promises = partlocalizations.map(async (item) => {
                const { id } = item;

                await PartLocalization.update(
                    {
                        status_id,
                        updated_by
                    },
                    {
                        logging: (value) => {
                            sqlLog += value
                        },
                        where: {
                            id
                        },
                        transaction: t

                    }
                );

            }
            );

            Promise.all(promises).then(async values => {

                await t.commit();
                logService.addLog('Sucesso ao atualizar requisição', 'INFO', '/requisitions', req.body, sqlLog, 'PATCH', req.headers, "Requisition")
            });



            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar requisição!' })

        } catch (err) {
            await t.rollback();
            logService.addLog(`Erro ao atualizar requisição!: ${err}`, 'INFO', '/requisitions', null, null, 'PATCH', req.headers, "Requisition")
            return res.stutus(400).json({ ERRO: `Erro ao atualizar requisição!: ${err}` })
        }

    },

    async updateEmprestimo(req, res) {

        const { id, updated_by, partlocalizations } = req.body;
        logService.addLog('updateEmprestimo', 'INFO', '/emprestimo', req.body, null, 'PATCH', req.headers, "Requisition")


        const t = await connection.transaction();

        try {
            const status_id = 1;
            let sqlLog
            await RequisitionStorage.destroy(
                {
                    logging: (value) => {
                        sqlLog = value
                    },
                    where: {
                        requisition_id: id
                    },
                    transaction: t
                });
            await Requisition.destroy(
                {
                    logging: (value) => {
                        sqlLog += value
                    },
                    where: {
                        id
                    },
                    transaction: t
                });

            const promises = partlocalizations.map(async (item) => {
                const { id } = item;


                await PartLocalization.update(
                    {
                        status_id,
                        updated_by
                    },
                    {
                        logging: (value) => {
                            sqlLog += value
                        },
                        where: {
                            id
                        },
                        transaction: t

                    });

            }
            );
            Promise.all(promises).then(async values => {
                await t.commit();
                logService.addLog('Sucesso ao atualziar empréstimo', 'INFO', '/emprestimo', req.body, sqlLog, 'PATCH', req.headers, "Requisition")

            });

            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar empréstimo!' })

        } catch (err) {
            await t.rollback();
            logService.addLog(`Erro ao atualizar empréstimo!: ${err}`, 'INFO', '/emprestimo', req.body, sqlLog, 'PATCH', req.headers, "Requisition")
            return res.stutus(400).json({ ERRO: `Erro ao atualizar empréstimo!: ${err}` })
        }

    },

    async criar(req, res) {

        const { id, updated_by, partlocalizations } = req.body;
        const status_id = 2;
        logService.addLog('Criar', 'INFO', '/loans', req.body, null, 'PATCH', req.headers, "Requisition")


        const t = await connection.transaction();

        try {
            let sqlLog
            const requisition = await Requisition.update(
                {
                    status_id,
                    updated_by
                },
                {
                    logging: (value) => {
                        sqlLog = value
                    },
                    where: {
                        id
                    },
                    transaction: t
                });

            const promises = partlocalizations.map(async (item) => {
                const { id } = item;


                await PartLocalization.update(
                    {
                        status_id,
                        updated_by
                    },
                    {
                        logging: (value) => {
                            sqlLog += value
                        },
                        where: {
                            id
                        },
                        transaction: t

                    });

            }
            );
            Promise.all(promises).then(async values => {
                await t.commit();
                logService.addLog('Sucesso ao atualizar requisição', 'INFO', '/loans', req.body, sqlLog, 'PATCH', req.headers, "Requisition")

            });

            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar requisição!' })

        } catch (err) {
            await t.rollback();
            logService.addLog(`Erro ao atualizar requisição!: ${err}`, 'INFO', '/loans', req.body, sqlLog, 'PATCH', req.headers, "Requisition")

            return res.stutus(400).json({ ERRO: `Erro ao atualizar requisição!: ${err}` })
        }

    },

    async index(req, res) {

        //const { os } = req.params;
        const { os, status_id } = req.body;
        logService.addLog('index', 'INFO', '/requisitions', req.body, null, 'POST', req.headers, "Requisition")

        try {
            let sqlLog
            const requisition = os ? await Requisition.findAll({
                //raw: true,
                attributes: ["id", "priority"],
                logging: (value) => {
                    sqlLog = value
                },
                where: {
                    // status_id: { [Op.eq]: 2, }
                    status_id
                },
                include: [
                    {
                        association: 'order',
                        attributes: ["id", "os", "contract_type", "customer_name", "part_number", "serial_number", "days"],
                        where: {
                            os: { [Op.substring]: os }

                        }
                    },
                    {
                        association: 'partlocalizations',
                        attributes: ['id'],
                        through: {
                            attributes: []
                        },
                        include: [
                            {
                                association: 'localizations',
                                attributes: ['address']
                            },
                            {
                                association: 'parts',
                                attributes: ['pn', 'description']
                            }

                        ],

                    },

                ]

            }) : await Requisition.findAll({
                attributes: ["id", "priority"],
                logging: (value) => {
                    sqlLog = value
                },
                where: {
                    //status_id: { [Op.eq]: 2, }
                    status_id
                },
                include: [
                    {
                        association: 'order',
                        attributes: ["os", "contract_type", "customer_name", "part_number", "serial_number", "days"],
                    },

                    {
                        association: 'partlocalizations',
                        attributes: ['id'],
                        through: {
                            attributes: []
                        },
                        include: [
                            {
                                association: 'localizations',
                                attributes: ['address']
                            },
                            {
                                association: 'parts',
                                attributes: ['pn', 'description']
                            }

                        ],
                    },
                ]

            });

            logService.addLog('Requisições encontradas', 'INFO', '/requisitions', req.body, sqlLog, 'POST', req.headers, "Requisition")
            return res.status(200).json(requisition);

        } catch (err) {
            logService.addLog(`Erro ao localizar requisição!:  ${err}`, 'INFO', '/requisitions', null, null, 'POST', req.headers, "Requisition")
            return res.status(400).json({ ERRO: `Erro ao localizar requisição!:  ${err}` })
        }
    },

    async indexReimpressao(req, res) {

        const { os } = req.body;
        logService.addLog('indexReimpressao', 'INFO', '/reimpressao', req.body, null, 'POST', req.headers, "Requisition")

        try {
            let sqlLog
            const requisition = await Requisition.findAll({
                //raw: true,
                attributes: ["id", "priority"],
                logging: (value) => {
                    sqlLog = value
                },
                where: {
                    status_id: { [Op.eq]: 3, }
                },
                include: [
                    {
                        association: 'order',
                        attributes: ["id", "os", "contract_type", "customer_name", "part_number", "serial_number", "days"],
                        where: {
                            os: { [Op.substring]: os }
                        }
                    },
                    {
                        association: 'partlocalizations',
                        attributes: ['id'],
                        through: {
                            attributes: []
                        },
                        include: [
                            {
                                association: 'localizations',
                                attributes: ['address']
                            },
                            {
                                association: 'parts',
                                attributes: ['pn', 'description']
                            }

                        ],

                    },

                ]

            });

            logService.addLog('Requisições encontradas', 'INFO', '/reimpressao', req.body, sqlLog, 'POST', req.headers, "Requisition")
            return res.status(200).json(requisition);

        } catch (err) {
            logService.addLog(`Erro ao localizar requisição!:  ${err}`, 'INFO', '/reimpressao', req.body, sqlLog, 'POST', req.headers, "Requisition")
            return res.status(400).json({ ERRO: `Erro ao localizar requisição!:  ${err}` })
        }
    }


};