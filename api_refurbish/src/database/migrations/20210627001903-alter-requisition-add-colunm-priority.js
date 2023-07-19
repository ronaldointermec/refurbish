'use strict';

module.exports = {
  up: (queryInterface, Sequelize) => {
    return Promise.all([
      queryInterface.addColumn(
        'requisitions',
        'priority',
        {
          type: Sequelize.BOOLEAN
        }
      ),
      ]);
  },

  down: (queryInterface, Sequelize) => {
    return Promise.all([
      queryInterface.removeColumn('requisitions', 'priority')
      
    ]);
  }
};
