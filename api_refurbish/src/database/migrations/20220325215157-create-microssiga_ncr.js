'use strict';

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('microsiga_ncrs', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      order_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'orders', key: 'id',
          onUpdate: 'CASCATE',
          onDelete: 'NO ACTION',
        },
      },
      status_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'status', key: 'id',
          onUpdate: 'CASCATE',
          onDelete: 'NO ACTION',
        },
      },
      pn: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      quantidade: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      position: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      desc_pn: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      motivo: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      desc_problema: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      tipo: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      mov_microsiga: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      created_by: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      updated_by: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
      },

    });
  },

  down: (queryInterface, Sequelize) => {

    return queryInterface.dropTable('microsiga_ncrs');

  }
};
