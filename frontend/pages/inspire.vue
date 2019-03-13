<template>
  <v-layout>
    <v-flex>
      <v-sheet height="400">
        <!-- now is normally calculated by itself, but to keep the calendar in this date range to view events -->
        <v-calendar
          ref="calendar"
          :now="today"
          :value="today"
          :day-format="day_formater"
          :intervalMinutes="slotSize"
          :first-interval="startSlot"
          :dark="true"
          :short-weekdays="false"
          :weekdays="[6,0,1,2,3,4]"
          color="primary"
          type="week"
        >
          <!-- the events at the top (all-day) -->
          <template #dayHeader="{ date }">
            <template v-for="event in eventsMap[date]">
              <!-- all day events don't have time -->
              <div
                v-if="!event.time"
                :key="event.title"
                @click="open(event)"
                v-html="event.title"
                class="my-event"
              />
            </template>
          </template>
          <!-- the events at the bottom (timed) -->
          <template #dayBody="{ date, timeToY, minutesToPixels }">
            <template v-for="event in eventsMap[date]">
              <!-- timed events -->
              <div
                v-if="event.time"
                :key="event.title"
                :style="{ top: timeToY(event.time) + 'px',
                          height: minutesToPixels(event.duration) + 'px' }"
                @click="open(event)"
                v-html="event.title"
                class="my-event with-time"
              />
            </template>
          </template>
        </v-calendar>
      </v-sheet>
    </v-flex>
  </v-layout>
</template>
<script>
export default {
  data: () => ({
    slotSize: 30,
    firstHour: 8.5,
    today: '2019-01-08',
    events: [
      {
        title: 'Weekly Meeting',
        date: '2019-01-07',
        time: '09:00',
        duration: 45
      },
      {
        title: "Thomas' Birthday",
        date: '2019-01-10'
      },
      {
        title: 'Mash Potatoes',
        date: '2019-01-09',
        time: '12:30',
        duration: 180
      }
    ]
  }),
  computed: {
    // convert the list of events into a map of lists keyed by date
    eventsMap() {
      const map = {}
      this.events.forEach(e => (map[e.date] = map[e.date] || []).push(e))
      return map
    },
    startSlot() {
      const wholeHour = Math.floor(this.firstHour)
      const start = wholeHour / (this.slotSize / 60)
      const addSlot = wholeHour !== this.firstHour ? 1 : 0
      return start + addSlot
    }
  },
  mounted() {
    this.$refs.calendar.scrollToTime('08:00')
  },
  methods: {
    open(event) {
      alert(event.title)
    },
    day_formater() {
      // return an empty string to remove day numbers
      return ''
    }
  }
}
</script>
<style lang="stylus" scoped>
  .my-event {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    border-radius: 2px;
    background-color: #1867c0;
    color: #ffffff;
    border: 1px solid #1867c0;
    font-size: 12px;
    padding: 3px;
    cursor: pointer;
    margin-bottom: 1px;
    left: 4px;
    margin-right: 8px;
    position: relative;

    &.with-time {
      position: absolute;
      right: 4px;
      margin-right: 0px;
    }
  }
</style>
