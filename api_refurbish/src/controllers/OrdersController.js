const Order = require('../models/Order');
const Requisition = require('../models/Requisition');
const RequisitionStorage = require('../models/RequisitionStorage');
const PartLocalization = require('../models/PartLocalization');
const { Sequelize, Op, where } = require('sequelize');
const Part = require('../models/Part');
const MicrosigaLoan = require('../models/MicrosigaLoan');

const connection = require('../database');
const { addLog } = require('../logServices');
module.exports = {
    async index(req, res) {
        const { os } = req.params;
        addLog(
            'Dentro do INDEX ' + os,
            'INFO',
            '/orders',
            req.params,
            null,
            req.method,
            req.headers,
            'Orders'
        );
        try {
            let sqlLog;
            const order = await Order.findAll({
                attributes: [
                    'os',
                    'contract_type',
                    'customer_name',
                    'part_number',
                    'serial_number',
                    'days',
                ],
                where: {
                    os: { [Op.substring]: os },
                },
                logging: (value) => {
                    sqlLog = value;
                },
            });
            addLog(
                `Encontrou ${order.length} ordens!`,
                'INFO',
                '/orders',
                req.params,
                sqlLog,
                req.method,
                req.headers,
                'Orders'
            );
            return res.status(200).json(order);
        } catch (err) {
            addLog(
                `Erro ao buscar as ordens!. Erro: ${err}`,
                'ERR',
                '/orders',
                req.params,
                null,
                req.method,
                req.headers,
                'Orders'
            );
            return res.status(400).json({ ERRO: `Erro ao locar OS ${err}` });
        }
    },

    async store(req, res) {
        const {
            os,
            contract_type,
            customer_name,
            part_number,
            serial_number,
            days,
            priority,
            status_id,
            created_by,
            storages, 
        } = req.body;

        addLog(
            'Dentro do STORE',
            'INFO',
            '/orders',
            req.body,
            null,
            req.method,
            req.headers,
            'Orders'
        );

        let temNoEstoque = true;

        //orderna storages (do menor para o maior) de acordo com o part_id
        var storagesOrder = storages.sort(function (a, b) {
            if (a.part_id > b.part_id) {
                return 1;
            }
            if (a.part_id < b.part_id) {
                return -1;
            }
            return 0;
        });

        // pegar posições diferentes, quando houver part_id iguais;
        var offset = 0;
        //salva part_id pesquisado anteriorente.
        var part_id_aux = -1;

        //Validate if there are  PNs available and retorn the id;
        const parts = await Promise.all(
            await storagesOrder.map(async (item) => {
                // se o part_id atual for igual ao antigo, igonara offset + uma linha.
                if (item.part_id === part_id_aux) {
                    offset = offset + 1;
                } else {
                    //ser offset atual for diferente do antigo, pega aprimiera linha (offset=0)
                    offset = 0;
                }
                // pega o part_id atual e grava para ser o antigo da próxima interação do map.
                part_id_aux = item.part_id;

                try {
                    let sqlLog;
                    const part = await Part.findAll({
                        offset: offset,
                        logging: (value) => {
                            sqlLog = value;
                        },
                        // order: [['pn', 'DESC']],
                        attributs: ['pn', 'description'],

                        raw: false,
                        where: {
                            id: { [Op.eq]: [item.part_id] },
                        },

                        include: [
                            {
                                association: 'localizations',
                                attributes: ['address'],
                                where: {
                                    address: {
                                        [Op.eq]: item.address,
                                    },
                                },
                                through: {
                                    distinct: true,
                                    attributes: ['id', 'status_id'],
                                    where: {
                                        status_id: 1,
                                    },
                                },
                            },
                        ],
                    });

                    // addLog(
                    //     `Existem ${part.length} items no estoque!`,
                    //     'INFO',
                    //     '/orders',
                    //     req.body,
                    //     sqlLog,
                    //     req.method,
                    //     req.headers,
                    //     'Orders'
                    // );

                    //console.log(`Quantidade Estoque ${part.length}`);
                    if (part.length === 0) {
                        const part = await Part.findByPk(item.part_id);
                        temNoEstoque = false;
                        addLog(
                            `Partnumer: ${part['pn']} não está mais disponível!`,
                            'ERR',
                            '/orders',
                            req.body,
                            sqlLog,
                            req.method,
                            req.headers,
                            'Orders'
                        );
                        return res
                            .status(400)
                            .json(`Partnumer: ${part['pn']} não está mais disponível!`);
                    } else {
                        var storagesFiltro = part.map((item, index) => {
                            return item.localizations;
                        });

                        var partlocalization_id = storagesFiltro.map((item, index) => {
                            return item[index]['part_localizations']['id'];
                        });

                        return partlocalization_id;
                    }
                } catch (err) {
                    addLog(
                        `Houve um erro: ${err}`,
                        'ERR',
                        '/orders',
                        req.body,
                        null,
                        req.method,
                        req.headers,
                        'Orders'
                    )
                    return res.status(400).json({ ERRO: `Houve um erro: ${err}` });
                }
            })
        );

        if (temNoEstoque) {
            const t = await connection.transaction();
            try {
                // const result = await connection.transaction(async (t) => {
                let sqlLog;
                ///Create or fetch an Order by OS
                const [order] = await Order.findOrCreate({
                    where: { os },
                    logging: (value) => {
                        sqlLog = value;
                    },
                    transaction: t,
                    defaults: {
                        contract_type,
                        customer_name,
                        part_number,
                        serial_number,
                        days,
                        created_by,
                    },
                });

                //Get Orders ID and user Id
                const order_id = order['id'];
                //this.created_by = order["created_by"];

                //Set Requisitions status as "processing" by using status 2
                //const status_id = 2;

                addLog(
                    `Tem ou criou a ordem ${order_id} no banco!`,
                    'INFO',
                    '/orders',
                    req.body,
                    sqlLog,
                    req.method,
                    req.headers,
                    'Orders'
                );

                //Create an Order
                const requisition = await Requisition.create(
                    {
                        priority,
                        order_id,
                        status_id,
                        created_by,
                    },
                    { transaction: t },
                    { logging: (value) => (sqlLog = value) }
                );

                const requisition_id = await requisition['id'];

                addLog(
                    `Criou a requisição ${requisition_id} no banco!`,
                    'INFO',
                    '/orders',
                    req.body,
                    sqlLog,
                    req.method,
                    req.headers,
                    'Orders'
                );

                //add all part add to the list.
                for (let index = 0; index < storagesOrder.length; index++) {
                    storagesOrder[index]['partlocalization_id'] = parts[index].join(' ');
                }

                //Fetch it item form de storages
                const promises = storagesOrder.map(async (item) => {
                    var { partlocalization_id, reason_id } = item;

                    //Create a relationship between Requisitons and Storages

                    await RequisitionStorage.create(
                        {
                            partlocalization_id,
                            requisition_id,
                            reason_id,
                            created_by,
                        },
                        { transaction: t },
                        { logging: (value) => (sqlLog = value) }
                    );

                    addLog(
                        `Criou uma relação entre a requisição ${requisition_id} e o estoque ${partlocalization_id} no banco!`,
                        'INFO',
                        '/orders',
                        req.body,
                        sqlLog,
                        req.method,
                        req.headers,
                        'Orders'
                    );

                    var updated_by = created_by;

                    //Update PartLocalizations items
                    await PartLocalization.update(
                        {
                            status_id,
                            updated_by,
                        },
                        {
                            where: {
                                id: partlocalization_id,
                            },
                            transaction: t,
                        },
                        { logging: (value) => (sqlLog = value) }
                    );

                    addLog(
                        `Atualizou o PartLocalizations item ${partlocalization_id}!`,
                        'INFO',
                        '/orders',
                        req.body,
                        sqlLog,
                        req.method,
                        req.headers,
                        'Orders'
                    );
                });
                
                Promise.all(promises).then(async (values) => {
                    await t.commit();
                });
                // });

                addLog(
                    `Sucesso ao criar requisição!`,
                    'INFO',
                    '/orders',
                    req.body,
                    sqlLog,
                    req.method,
                    req.headers,
                    'Orders'
                );

                return res.status(200).json({ SUCESSO: 'Sucesso ao criar requisição' });
            } catch (err) {
                console.log(err);
                addLog(
                    `Erro ao criar requisição!: ${err}`,
                    'ERR',
                    '/orders',
                    req.body,
                    sqlLog,
                    req.method,
                    req.headers,
                    'Orders'
                );
                await t.rollback();
                return res.status(400).json({ ERRO: `Erro ao criar requisição!: ${err}` });
            }
        } else {
            console.log('Estoque unsuficiente!');
            addLog(
                `Estoque unsuficiente!`,
                'ERR',
                '/orders',
                req.body,
                null,
                req.method,
                req.headers,
                'Orders'
            );
            return res;
        }
    },
};
