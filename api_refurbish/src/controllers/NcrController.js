const Order = require('../models/Order');
const { Sequelize, Op, where } = require('sequelize');
const MicrosigaNcr = require('../models/MicrosigaNcr');
const connection = require('../database');
const { addLog } = require('../logServices');

module.exports = {
    async update(req, res) {
        const { id, status_id, mov_microsiga, updated_by } = req.body;
        //console.log(`id: ${id} status_id: ${status_id} updated_by: ${updated_by}`);
        addLog(
            `Dentro do UPDATE. Valores passados: id: ${id} status_id: ${status_id} updated_by: ${updated_by}`,
            'INFO',
            '/ncr',
            req.body,
            null,
            req.method,
            req.headers,
            'Ncr'
        );

        const t = await connection.transaction();
        try {
            let sqlLog;
            await MicrosigaNcr.update(
                {
                    status_id,
                    mov_microsiga,
                    updated_by,
                },
                {
                    where: {
                        id,
                    },
                    transaction: t,
                    logging: (value) => {
                        sqlLog = value;
                    },
                }
            );

            await t.commit();
            addLog(
                `NCR ${id} atualizada com sucesso!`,
                'INFO',
                '/ncr',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'Ncr'
            );
            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar requisicão!' });
        } catch (err) {
            await t.rollback();
            addLog(
                `ERRO AO ATUALIZAR NCR. Erro: ${err}`,
                'ERR',
                '/ncr',
                req.body,
                null,
                req.method,
                req.headers,
                'Ncr'
            );
            return res.status(400).json({ ERRO: `Erro ao atualizar empréstimo!: ${err}` });
        }
    },

    async index(req, res) {
        const { os } = req.params;
        addLog(`Dentro do INDEX`, 'INFO', '/ncr', req.params, null, req.method, req.headers, 'Ncr');
        try {
            let sqlLog;
            const msl = os
                ? await MicrosigaNcr.findAll({
                      //raw: true,
                      logging: (value) => {
                          sqlLog = value;
                      },
                      attributes: [
                          'id',
                          'status_id',
                          'pn',
                          'quantidade',
                          'position',
                          'desc_pn',
                          'motivo',
                          'desc_problema',
                          'tipo',
                          'updated_by',
                      ],
                      where: {
                          status_id: { [Op.ne]: 3 },
                      },
                      include: [
                          {
                              association: 'order',
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
                          },
                          // {
                          //     association: "status",
                          //     attributes: ["message"],

                          // }
                      ],
                  })
                : await MicrosigaNcr.findAll({
                      //raw: true,
                      logging: (value) => {
                          sqlLog = value;
                      },
                      attributes: [
                          'id',
                          'status_id',
                          'pn',
                          'quantidade',
                          'position',
                          'desc_pn',
                          'motivo',
                          'desc_problema',
                          'tipo',
                          'updated_by',
                      ],
                      where: {
                          status_id: { [Op.ne]: 3 },
                      },
                      include: [
                          {
                              association: 'order',
                              attributes: [
                                  'os',
                                  'contract_type',
                                  'customer_name',
                                  'part_number',
                                  'serial_number',
                                  'days',
                              ],
                          },
                          // {
                          //     association: "status",
                          //     attributes: ["message"],

                          // }
                      ],
                  });
            addLog(
                `NCRs encontradas com sucesso!`,
                'INFO',
                '/ncr',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'Ncr'
            );
            return res.status(200).json(msl);
        } catch (err) {
            addLog(
                `ERRO AO BUSCAR NCRs. Erro: ${err}`,
                'ERR',
                '/ncr',
                req.params,
                null,
                req.method,
                req.headers,
                'Ncr'
            );
            return res.status(400).json({ erro: 'deu ruim' });
        }
    },

    async store(req, res) {
        const {
            order,
            pn,
            quantidade,
            position,
            desc_pn,
            motivo,
            desc_problema,
            tipo,
            created_by,
            status_id,
        } = req.body;

        addLog('Dentro do STORE', 'INFO', '/ncr', req.body, null, req.method, req.headers, 'Ncr');

        const { os, contract_type, customer_name, part_number, serial_number, days } = order;
        const t = await connection.transaction();

        try {
            let sqlLog;
            const [orderDB] = await Order.findOrCreate({
                where: { os },
                transaction: t,
                logging: (value) => {
                    sqlLog = value;
                },
                defaults: {
                    contract_type,
                    customer_name,
                    part_number,
                    serial_number,
                    days,
                    created_by,
                },
            });

            addLog(
                `Ordem ${JSON.stringify(os)} criada ou encontrada com sucesso!`,
                'INFO',
                '/ncr',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'Ncr'
            );

            const order_id = orderDB['id'];

            if (order_id != null) {
                await MicrosigaNcr.create(
                    {
                        order_id,
                        status_id,
                        pn,
                        quantidade,
                        position,
                        desc_pn,
                        motivo,
                        desc_problema,
                        tipo,
                        created_by,
                    },
                    {
                        transaction: t,
                        logging: (value) => {
                            sqlLog = value;
                        },
                    }
                );
            }
            addLog(
                `NCR criada com sucesso!`,
                'INFO',
                '/ncr',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'Ncr'
            );
            await t.commit();
            return res.status(200).json({ SUCESSO: 'Sucesso ao criar NCR' });
        } catch (err) {
            //console.log(err);
            addLog(
                `ERRO AO CRIAR NCR. Erro: ${err}`,
                'ERR',
                '/ncr',
                req.body,
                null,
                req.method,
                req.headers,
                'Ncr'
            )
            await t.rollback();
            return res.status(400).json({ ERRO: `Erro ao criar NCR!: ${err}` });
        }
    },
};
