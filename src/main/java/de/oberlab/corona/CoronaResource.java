package de.oberlab.corona;


import de.oberlab.corona.model.CoronaFaelle;
import de.oberlab.corona.model.Landkreise;
import org.graalvm.polyglot.Source;
import org.graalvm.polyglot.Value;
import org.jboss.resteasy.annotations.jaxrs.PathParam;
import org.graalvm.polyglot.Context;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.io.IOException;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Path("/corona")
public class CoronaResource {

    public static Context context = Context.newBuilder("R")
            .allowAllAccess(true)
            .allowHostClassLoading(true)
            .allowIO(true)
            .allowNativeAccess(true)
            .allowCreateThread(true)
            .build();

    @GET
    @Path("/landkreise")
    @Produces(MediaType.APPLICATION_JSON)
    public Object alleLandkreise() throws IOException {
        final URL coronaMB = getClass().getClassLoader().getResource("landkreise.R");
        context.getBindings("R").putMember("result",new Landkreise());

        Value landkreisListeR = context.eval(Source.newBuilder("R",coronaMB).build());
        Object result = landkreisListeR.asHostObject();
        return result;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/landkreis/{id}")
    public Object corona(@PathParam String id) throws IOException {

        final URL coronaLkr = getClass().getClassLoader().getResource("coronaLkr.R");
        context.getBindings("R").putMember("landkreisId",id);
        context.getBindings("R").putMember("result",new CoronaFaelle());
        Value landkreisResult = context.eval(Source.newBuilder("R",coronaLkr).build());
        CoronaFaelle result = landkreisResult.asHostObject();
        LinkedHashMap<String, Integer> resultMap = result.faelleFuerLandkreis.entrySet().stream().sorted(Map.Entry.comparingByKey()).collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue,
                (oldValue, newValue) -> oldValue, LinkedHashMap::new));
        result.faelleFuerLandkreis = resultMap;
        return result;
    }

}
