'use strict';

const Sequelize = require('sequelize');

module.exports = {
  up: (queryInterface, Sequelize) => {

    return queryInterface.createTable('microsiga_status_messages', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      message: {
        type: Sequelize.STRING,
        allowNull: false,
        //unique: true,
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

    return queryInterface.dropTable('microsiga_status_messages');

  }
};
