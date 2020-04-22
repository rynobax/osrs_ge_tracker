import { Socket } from 'phoenix';

const socket = new Socket('/socket');

socket.connect();

const width = 400;
const height = 200;
const curve = d3.curveStep;
const colors = [d3.schemeRdYlBu[3][2], d3.schemeRdYlBu[3][0]];
const margin = { top: 20, right: 20, bottom: 30, left: 30 };

if (!window.osrs_ge_tracker) window.osrs_ge_tracker = {};
window.osrs_ge_tracker.chart_hourly = ids => {
  console.log(ids);
  ids.forEach(id => {
    const channel = socket.channel(`chart:${id}`, {});
    channel
      .join()
      .receive('ok', ({ data }) => {
        console.log({ data });
        const el = document.getElementById(`card-chart-${id}`);
        const svg = d3.create('svg').attr('viewBox', [0, 0, width, height]);
        console.log({ svg })
        el.append(svg);

        const aboveUid = 'above';
        const belowUid = 'below';

        const x = d3
          .scaleTime()
          .domain(d3.extent(data, d => d.inserted_at))
          .range([margin.left, width - margin.right]);

        const xAxis = g =>
          g
            .attr('transform', `translate(0,${height - margin.bottom})`)
            .call(
              d3
                .axisBottom(x)
                .ticks(width / 80)
                .tickSizeOuter(0)
            )
            .call(g => g.select('.domain').remove());

        const y = d3
          .scaleLinear()
          .domain([
            d3.min(data, d => Math.min(d.buy_avg, d.sell_avg)),
            d3.max(data, d => Math.max(d.buy_avg, d.sell_avg))
          ])
          .nice(5)
          .range([height - margin.bottom, margin.top]);

        const yAxis = g =>
          g
            .append('g')
            .attr('transform', `translate(${margin.left},0)`)
            .call(d3.axisLeft(y))
            .call(g => g.select('.domain').remove())
            .call(g =>
              g
                .select('.tick:last-of-type text')
                .clone()
                .attr('x', 3)
                .attr('text-anchor', 'start')
                .attr('font-weight', 'bold')
                .text('price')
            );
        svg.append('g').call(xAxis);
        svg.append('g').call(yAxis);
        svg
          .append('clipPath')
          .attr('id', aboveUid.id)
          .append('path')
          .attr(
            'd',
            d3
              .area()
              .curve(curve)
              .x(d => x(d.inserted_at))
              .y0(0)
              .y1(d => y(d.sell_avg))
          );

        svg
          .append('clipPath')
          .attr('id', belowUid.id)
          .append('path')
          .attr(
            'd',
            d3
              .area()
              .curve(curve)
              .x(d => x(d.inserted_at))
              .y0(height)
              .y1(d => y(d.sell_avg))
          );

        svg
          .append('path')
          .attr('clip-path', aboveUid)
          .attr('fill', colors[1])
          .attr(
            'd',
            d3
              .area()
              .curve(curve)
              .x(d => x(d.inserted_at))
              .y0(height)
              .y1(d => y(d.buy_avg))
          );

        svg
          .append('path')
          .attr('clip-path', belowUid)
          .attr('fill', colors[0])
          .attr(
            'd',
            d3
              .area()
              .curve(curve)
              .x(d => x(d.inserted_at))
              .y0(0)
              .y1(d => y(d.buy_avg))
          );

        svg
          .append('path')
          .attr('fill', 'none')
          .attr('stroke', 'black')
          .attr('stroke-width', 1.5)
          .attr('stroke-linejoin', 'round')
          .attr('stroke-linecap', 'round')
          .attr(
            'd',
            d3
              .line()
              .curve(curve)
              .x(d => x(d.inserted_at))
              .y(d => y(d.buy_avg))
          );
      })
      .receive('error', resp => {
        console.log('Unable to join', resp);
      });
  });
};

export default socket;
