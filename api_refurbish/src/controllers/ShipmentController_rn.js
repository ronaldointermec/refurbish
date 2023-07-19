const Shipment = require('../models/Shipment');
const { Op } = require('sequelize');
const connection = require('../database');




module.exports = {

    async store(req, res) {

            const { os, local, is_lab, status_id, created_by } = req.body;
             console.log(req.body)
           // os = "999999"

        const t = await connection.transaction();
        try {

            const [shipment, isNew] = await Shipment.findOrCreate(
                {
                    where: { os, local, is_lab, status_id, created_by },
                    transaction: t,
                    // defaults:{}
                });


            if (isNew) {
                await t.commit();
       
                return res.status(200).json("Sucesso ao alocar!");
              
            }
            await t.commit();
                return res.status(202).json("Já foi realizada alocação com um dos dados informados!");

        } catch (err) {
            console.log(`erro ao salvar: ${err}`)
            await t.rollback();
            return res.status(400).json({ ERROR: `Erro ao alocar!: ${err}` })
        }
     
    },

    async index(req, res) {

        const { os, is_lab} = req.body;

         if(is_lab !==null && is_lab===true){

        try {

            const shipment = os ? await Shipment.findAll({
                where: {
                    os,
                    //os: { [Op.substring]: os },
                    is_lab: true,
                },
                order: [['updated_at', 'DESC']],
                limit: 1,

            }) : await Shipment.findAll({
                where: {
                    is_lab: true,
                    status_id: 2
                },
                order: [['updated_at', 'DESC']],
                //limit: 1,

            });

            /* if (shipment === 0) {
                return res.status(400).json({ VALIDAÇÃO: 'Shipment não foi localizado' })
            } */

            console.log(`shipment: ${shipment}`)

            res.status(200).json(shipment);

        } catch (err) {

            res.status(400).json({ ERROR: `Erro ao recuperar shipments!: ${err}` })
        }
    } else{
        try {
            const shipment = os ? await Shipment.findAll({
                where: {
                    //os:{[Op.like]:os},
                    os: { [Op.substring]: os },
                    is_lab: false,
                    status_id: 2
                },
                order: [['updated_at', 'DESC']],

            }) : await Shipment.findAll({
                where: {
                    is_lab: false,
                    status_id: 2
                },
                order: [['updated_at', 'DESC']],

            })  ;

            /*  if (shipment === 0) {
                 return res.status(400).json({ VALIDAÇÃO: 'Shipment não foi localizado' })
             } */
             console.log(`shipment: ${shipment}`)
            res.status(200).json(shipment);

        } catch (err) {

            res.status(400).json({ ERROR: `Erro ao recuperar shipments!: ${err}` })
        }

    }
    },

    async update(req, res) {

        const { id, status_id, updated_by } = req.body;

        const t = await connection.transaction();
        try {

            const shipment = await Shipment.update(
                {
                    status_id,
                    updated_by,
                },
                {
                    where: {
                        id
                    }, transaction: t
                }
            );

            await t.commit();
            return res.status(200).json({ SUCESSO: 'Sucesso ao atualizar shipment!' })

        } catch (err) {
            await t.rollback();
            return res.stutus(400).json({ ERRO: `Erro ao atualizar shipment!: ${err}` })
        }


    }


    
};