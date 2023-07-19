'use strict';
const Sequelize = require('sequelize');

module.exports = {
  up: (queryInterface, Sequelize) => {


    return queryInterface.createTable('requisition_storages', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      partlocalization_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'part_localizations', key: 'id',
          onUpdate: 'CASCATE',
          onDelete: 'NO ACTION',
        },
      },
       requisition_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'requisitions', key: 'id',
          onUpdate: 'CASCATE',
          onDelete: 'NO ACTION',
        },
      },
      reason_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'reasons', key: 'id',
          onUpdate: 'CASCATE',
          onDelete: 'NO ACTION',
        },
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

    return queryInterface.dropTable('requisition_storages');

  }
};
