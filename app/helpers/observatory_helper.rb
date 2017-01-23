# Helper methods defined here can be accessed in any controller or view in the application

module Observatory
  class App
    module ObservatoryHelper
      def scheduled_player_updates_graph()
        line_chart(
          url(:observatory, :scheduled_player_updates_graph),
          curve: true,
          xtitle: 'Hour',
          ytitle: 'Updates',
          download: "scheduled_player_updates",
          legend: false,
          library: {
            title: {
              display: true,
              text: 'Scheduled Player Updates',
            }
          }
        )
      end

      def player_update_frequencies_graph()
        bar_chart(
          url(:observatory, :player_update_frequencies_graph),
          download: "player_update_frequencies",
          legend: true,
          library: {
            title: {
              display: true,
              text: 'Player Update Frequencies',
            }
          }
        )
      end

      def player_data_points_relevance_graph()
        pie_chart(
          url(:observatory, :player_data_points_relevance_graph),
          download: "player_data_points_relevance",
          legend: true,
          library: {
            title: {
              display: true,
              text: 'Player Data Points Relevance',
            }
          }
        )
      end

      def player_queries_graph()
        line_chart(
          url(:observatory, :player_queries_graph),
          curve: true,
          ytitle: 'Queries',
          download: "manual_player_queries",
          legend: false,
          library: {
            title: {
              display: true,
              text: 'Manual Player Queries',
            }
          }
        )
      end
    end

    helpers ObservatoryHelper
  end
end