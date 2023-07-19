const Order = require("../models/Order");
const { Sequelize, Op, where } = require("sequelize");
const MicrosigaLoan = require("../models/MicrosigaLoan");

const connection = require('../database');
const { addLog } = require('../logServices');

module.exports = {
    async update(req, res) {
        const { id, status_id, updated_by } = req.body;
        addLog(
            `Dentro de UPDATE. Atualizando o MicrosigaLoan com id: ${id} para o status ${status_id}...`,
            'INFO',
            '/loan',
            req.body,
            null,
            req.method,
            req.headers,
            'MicrosigaLoan'
        );
        const t = await connection.transaction();
        try {
            let sqlLog;
            await MicrosigaLoan.update(
                {
                    status_id,
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
                `UPDATE realizado com sucesso!`,
                'INFO',
                '/loan',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'MicrosigaLoan'
            );
            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar requisicão!' });
        } catch (err) {
            await t.rollback();
            addLog(
                `Erro ao atualizar o MicrosigaLoan com id: ${id} para o status ${status_id}! Erro: ${err}`,
                'ERR',
                '/loan',
                req.body,
                null,
                req.method,
                req.headers,
                'MicrosigaLoan'
            );
            return res.status(400).json({ ERRO: `Erro ao atualizar empréstimo!: ${err}` });
        }
    },

    async index(req, res) {
        const { os } = req.params;
        addLog(
            'Dentro do INDEX',
            'INFO',
            '/loan',
            req.query,
            null,
            req.method,
            req.headers,
            'MicrosigaLoan'
        );
        try {
            let sqlLog;
            const msl = os
                ? await MicrosigaLoan.findAll({
                      //raw: true,
                      logging: (value) => {
                          sqlLog = value;
                      },
                      attributes: [
                          'id',
                          'status_id',
                          'pn',
                          'position',
                          'description',
                          'updated_by',
                      ],
                      where: {
                          status_id: { [Op.ne]: 5 },
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
                          {
                              association: 'status',
                              attributes: ['message'],
                          },
                      ],
                  })
                : await MicrosigaLoan.findAll({
                      //raw: true,
                      logging: (value) => {
                          sqlLog = value;
                      },
                      attributes: [
                          'id',
                          'status_id',
                          'pn',
                          'position',
                          'description',
                          'updated_by',
                      ],
                      where: {
                          status_id: { [Op.ne]: 5 },
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
                          {
                              association: 'status',
                              attributes: ['message'],
                          },
                      ],
                  });
            addLog(
                'Busca realizada com sucesso!',
                'INFO',
                '/loan',
                req.query,
                sqlLog,
                req.method,
                req.headers,
                'MicrosigaLoan'
            );
            return res.status(200).json(msl);
        } catch (err) {
            addLog(
                `Erro ao buscar empréstimos! Erro: ${err}`,
                'ERR',
                '/loan',
                req.query,
                null,
                req.method,
                req.headers,
                'MicrosigaLoan'
            );
            return res.status(400).json({ erro: 'deu ruim' });
        }
    },

    async store(req, res) {
        const { order, item, created_by, status_id } = req.body;

        const { os, contract_type, customer_name, part_number, serial_number, days } = order;
        const { pn, position, description } = item;

        addLog(
            'Dentro do STORE',
            'INFO',
            '/loan',
            req.body,
            null,
            req.method,
            req.headers,
            'MicrosigaLoan'
        );

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

            const order_id = orderDB['id'];

            if (order_id != null) {
                await MicrosigaLoan.create(
                    {
                        order_id,
                        status_id,
                        pn,
                        position,
                        description,
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

            await t.commit();
            addLog(
                'Empréstimo cadastrado com sucesso!',
                'INFO',
                '/loan',
                req.body,
                sqlLog,
                req.method,
                req.headers,
                'MicrosigaLoan'
            );
            return res.status(200).json({ SUCESSO: 'Sucesso ao criar requisição' });
        } catch (err) {
            console.log(err);
            await t.rollback();
            addLog(
                `Erro ao cadastrar empréstimo! Erro: ${err}`,
                'ERR',
                '/loan',
                req.body,
                null,
                req.method,
                req.headers,
                'MicrosigaLoan'
            );
            return res.status(400).json({ ERRO: `Erro ao criar requisição!: ${err}` });
        }
    },
};
