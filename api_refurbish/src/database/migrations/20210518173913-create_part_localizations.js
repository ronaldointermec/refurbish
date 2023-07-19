'use strict';
const Sequelize = require('sequelize');

module.exports = {
  up: (queryInterface, Sequelize) => {


    return queryInterface.createTable('part_localizations', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      part_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'parts', key: 'id',
          onUpdate: 'CASCATE',
          onDelete: 'NO ACTION',
        },

      },
      localization_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'localizations', key: 'id',
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

    return queryInterface.dropTable('part_localizations');

  }
};
